import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/errorLogHelper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/shared/premiumAnimatePage.dart';
import 'package:readr_app/services/loginService.dart';
import 'package:readr_app/services/memberService.dart';

enum LoginLoadingType { google, facebook, apple, email }

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  final LoginRepos loginRepos;
  final MemberBloc memberBloc;

  final String? routeName;
  final Map? routeArguments;

  LoginBloc({
    required this.loginRepos,
    required this.memberBloc,
    required this.routeName,
    this.routeArguments,
  }) : super(LoadingUI()) {
    on<CheckIsLoginOrNot>(_onCheckIsLoginOrNot);
    on<SignInWithGoogle>(_signInWithGoogle);
    on<SignInWithFacebook>(_signInWithFacebook);
    on<SignInWithApple>(_signInWithApple);
    on<FetchSignInMethodsForEmail>(_fetchSignInMethodsForEmail);
    on<SignOut>(_onSignOut);
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  MemberService _memberService = MemberService();
  ErrorLogHelper _errorLogHelper = ErrorLogHelper();
  LoginLoadingType? _loginLoadingType;

  Future<void> _handleFirebaseThirdPartyLogin(
    FirebaseLoginStatus frebaseLoginStatus,
    Emitter<LoginState> emit,
  ) async {
    if (frebaseLoginStatus.status == FirebaseStatus.Cancel) {
      emit(LoginInitState());
    } else if (frebaseLoginStatus.status == FirebaseStatus.Success) {
      bool isNewUser = false;
      if (frebaseLoginStatus.message is UserCredential) {
        UserCredential userCredential = frebaseLoginStatus.message;
        isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      }
      await _handleCreateMember(isNewUser, emit);
    } else if (frebaseLoginStatus.status == FirebaseStatus.Error) {
      _errorLogHelper.record(
          'HandleFirebaseThirdPartyLogin', {}, frebaseLoginStatus.toString());

      if (frebaseLoginStatus.message is FirebaseAuthException &&
          frebaseLoginStatus.message.code ==
              'account-exists-with-different-credential') {
        await _checkThirdPartyLoginEmail(frebaseLoginStatus, emit);
      } else {
        emit(LoginFail(
          error: UnknownException(frebaseLoginStatus.message),
        ));
      }
    }
  }

  Future<void> _handleCreateMember(
    bool isNewUser,
    Emitter<LoginState> emit,
  ) async {
    bool createSuccess = true;
    if (isNewUser) {
      print('CreateMember');
      String token = await _auth.currentUser!.getIdToken();
      createSuccess = await _memberService.createMember(
          _auth.currentUser!.email, _auth.currentUser!.uid, token);
    }
    if (createSuccess) {
      await _fetchMemberSubscriptionTypeToLogin(emit);
    } else {
      try {
        await _auth.currentUser!.delete();
      } catch (e) {
        print(e);
        await _auth.signOut();
      }

      _errorLogHelper.record(
          'HandleCreateMember', {'isNewUser': isNewUser}, 'Create member fail');

      emit(LoginFail(
        error: UnknownException('Create member fail'),
      ));
    }
  }

  Future<void> _checkThirdPartyLoginEmail(
    FirebaseLoginStatus frebaseLoginStatus,
    Emitter<LoginState> emit,
  ) async {
    try {
      String email = frebaseLoginStatus.message.email;
      List<String> signInMethodsStringList =
          await LoginServices().fetchSignInMethodsForEmail(email);

      if (signInMethodsStringList.contains('google.com')) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByGoogleMethodWarningMessage));
      } else if (signInMethodsStringList.contains('facebook.com')) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByFacebookMethodWarningMessage));
      } else if (signInMethodsStringList.contains('apple.com')) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByAppleMethodWarningMessage));
      } else if (signInMethodsStringList.contains('password')) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByPasswordMethodWarningMessage));
      } else {
        emit(LoginFail(error: UnknownException(frebaseLoginStatus.message)));
      }
    } on SocketException {
      emit(
        LoginFail(error: NoInternetException('No Internet')),
      );
    } on HttpException {
      emit(
        LoginFail(error: NoServiceFoundException('No Service Found')),
      );
    } on FormatException {
      emit(
        LoginFail(error: InvalidFormatException('Invalid Response format')),
      );
    } catch (e) {
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  Future<void> _renderingUiAfterEmailLogin(
    Emitter<LoginState> emit,
  ) async {
    if (_auth.currentUser == null) {
      emit(LoginInitState());
    } else {
      await _fetchMemberSubscriptionTypeToLogin(emit);
    }
  }

  Future<void> _fetchMemberSubscriptionTypeToLogin(
    Emitter<LoginState> emit,
  ) async {
    try {
      MemberIdAndSubscriptionType memberIdAndSubscriptionType =
          await _memberService.checkSubscriptionType(_auth.currentUser!);
      if (premiumSubscriptionType
          .contains(memberIdAndSubscriptionType.subscriptionType)) {
        if (_loginLoadingType == LoginLoadingType.email) {
          emit(FetchSignInMethodsForEmailLoading());
        } else {
          LoginType loginType = LoginType.google;
          if (_loginLoadingType == LoginLoadingType.facebook) {
            loginType = LoginType.facebook;
          } else if (_loginLoadingType == LoginLoadingType.apple) {
            loginType = LoginType.apple;
          }

          emit(LoginLoading(loginType: loginType));
        }
      } else {
        emit(LoginSuccess(
          israfelId: memberIdAndSubscriptionType.israfelId!,
          subscriptionType: memberIdAndSubscriptionType.subscriptionType!,
          isNewebpay: memberIdAndSubscriptionType.isNewebpay,
        ));
      }

      memberBloc.add(UpdateSubscriptionType(
          isLogin: true,
          israfelId: memberIdAndSubscriptionType.israfelId,
          subscriptionType: memberIdAndSubscriptionType.subscriptionType));

      Fluttertoast.showToast(
          msg: '登入成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      _navigateToRouteName(memberIdAndSubscriptionType.subscriptionType!);
    } catch (e) {
      // fetch member subscrition type fail
      print(e.toString());

      _errorLogHelper.record(
          'FetchMemberSubscriptionTypeToLogin', {}, e.toString());

      emit(LoginFail(
          error: UnknownException('Fetch member subscrition type fail')));
    }
  }

  Future<void> runPremiumAnimation() async {
    await RouteGenerator.navigatorKey.currentState!
        .pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AnimatePage(transitionAnimation: animation),
      transitionDuration: const Duration(milliseconds: 1500),
      reverseTransitionDuration: const Duration(milliseconds: 1000),
    ));
  }

  void _navigateToRouteName(SubscriptionType subscriptionType) async {
    bool backToHome = false;
    if (premiumSubscriptionType.contains(subscriptionType)) {
      await runPremiumAnimation();
      if (routeName != null && routeName == RouteGenerator.subscriptionSelect) {
        backToHome = true;
        RouteGenerator.navigatorKey.currentState!.pop();
      }
    }

    if (routeName != null && !backToHome) {
      if (routeArguments != null &&
          routeArguments!.containsKey('subscriptionType')) {
        routeArguments!.update('subscriptionType', (value) => subscriptionType);
      }

      if (premiumSubscriptionType.contains(subscriptionType)) {
        // await premium animation pop completed
        await Future.delayed(Duration(seconds: 1));
      }

      RouteGenerator.navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName!,
        ModalRoute.withName(RouteGenerator.root),
        arguments: routeArguments,
      );
    }
  }

  void _onCheckIsLoginOrNot(
    CheckIsLoginOrNot event,
    Emitter<LoginState> emit,
  ) async {
    print(event.toString());
    if (_auth.currentUser == null) {
      emit(LoginInitState());
    } else {
      try {
        MemberIdAndSubscriptionType memberIdAndSubscriptionType =
            await _memberService.checkSubscriptionType(_auth.currentUser!);
        emit(LoginSuccess(
          israfelId: memberIdAndSubscriptionType.israfelId!,
          subscriptionType: memberIdAndSubscriptionType.subscriptionType!,
          isNewebpay: memberIdAndSubscriptionType.isNewebpay,
        ));

        memberBloc.add(UpdateSubscriptionType(
            isLogin: true,
            israfelId: memberIdAndSubscriptionType.israfelId,
            subscriptionType: memberIdAndSubscriptionType.subscriptionType));

        if (premiumSubscriptionType
            .contains(memberIdAndSubscriptionType.subscriptionType)) {
          await runPremiumAnimation();
        }
      } catch (e) {
        // there is no member in israfel
        if (e.toString() == "Invalid Request: $memberStateTypeIsNotFound") {
          try {
            await _auth.currentUser!.delete();
          } catch (e) {
            print(e);
            await _auth.signOut();
          }
        }
        // when member subscrition type is not active
        else if (e.toString() ==
            "Invalid Request: $memberStateTypeIsNotActive") {
          await _auth.signOut();
        }
        // when there is no member in israfel and firebase id is deleted
        // reason: change Saleor to Isrefel and delete the third party firebase account
        else if (e.toString().contains('no user exists with the uid')) {
          await _auth.signOut();
        }

        _errorLogHelper.record(
            event.eventName(), event.eventParameters(), e.toString());
        print(e.toString());
        emit(LoginFail(
            error: UnknownException('Fetch member subscrition type fail')));
      }
    }
  }

  void _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    print(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.google;
      emit(LoginLoading(loginType: LoginType.google));
      FirebaseLoginStatus frebaseLoginStatus =
          await loginRepos.signInWithGoogle();
      await _handleFirebaseThirdPartyLogin(
        frebaseLoginStatus,
        emit,
      );
    } on SocketException {
      emit(
        LoginFail(error: NoInternetException('No Internet')),
      );
    } on HttpException {
      emit(
        LoginFail(error: NoServiceFoundException('No Service Found')),
      );
    } on FormatException {
      emit(
        LoginFail(error: InvalidFormatException('Invalid Response format')),
      );
    } catch (e) {
      _errorLogHelper.record(
          event.eventName(), event.eventParameters(), e.toString());
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  void _signInWithFacebook(
    SignInWithFacebook event,
    Emitter<LoginState> emit,
  ) async {
    print(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.facebook;
      emit(LoginLoading(loginType: LoginType.facebook));
      FirebaseLoginStatus frebaseLoginStatus =
          await loginRepos.signInWithFacebook();
      await _handleFirebaseThirdPartyLogin(
        frebaseLoginStatus,
        emit,
      );
    } on SocketException {
      emit(
        LoginFail(error: NoInternetException('No Internet')),
      );
    } on HttpException {
      emit(
        LoginFail(error: NoServiceFoundException('No Service Found')),
      );
    } on FormatException {
      emit(
        LoginFail(error: InvalidFormatException('Invalid Response format')),
      );
    } catch (e) {
      _errorLogHelper.record(
          event.eventName(), event.eventParameters(), e.toString());
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  void _signInWithApple(
    SignInWithApple event,
    Emitter<LoginState> emit,
  ) async {
    print(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.apple;
      emit(LoginLoading(loginType: LoginType.apple));
      FirebaseLoginStatus frebaseLoginStatus =
          await loginRepos.signInWithApple();
      await _handleFirebaseThirdPartyLogin(
        frebaseLoginStatus,
        emit,
      );
    } on SocketException {
      emit(
        LoginFail(error: NoInternetException('No Internet')),
      );
    } on HttpException {
      emit(
        LoginFail(error: NoServiceFoundException('No Service Found')),
      );
    } on FormatException {
      emit(
        LoginFail(error: InvalidFormatException('Invalid Response format')),
      );
    } catch (e) {
      _errorLogHelper.record(
          event.eventName(), event.eventParameters(), e.toString());
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  // need to refactor route
  void _fetchSignInMethodsForEmail(
    FetchSignInMethodsForEmail event,
    Emitter<LoginState> emit,
  ) async {
    print(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.email;
      emit(FetchSignInMethodsForEmailLoading());
      List<String> signInMethodsStringList =
          await loginRepos.fetchSignInMethodsForEmail(event.email);

      if (signInMethodsStringList.length == 1 &&
          signInMethodsStringList.contains('google.com')) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByGoogleMethodWarningMessage));
      } else if (signInMethodsStringList.length == 1 &&
          signInMethodsStringList.contains('facebook.com')) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByFacebookMethodWarningMessage));
      } else if (signInMethodsStringList.length == 1 &&
          signInMethodsStringList.contains('apple.com')) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByAppleMethodWarningMessage));
      } else if (signInMethodsStringList.contains('password')) {
        await RouteGenerator.navigateToEmailLogin(email: event.email);
        await _renderingUiAfterEmailLogin(emit);
      } else if (signInMethodsStringList.contains('emailLink')) {
        await RouteGenerator.navigateToPasswordResetPrompt(email: event.email);
        await _renderingUiAfterEmailLogin(emit);
      } else {
        await RouteGenerator.navigateToEmailRegistered(email: event.email);
        await _renderingUiAfterEmailLogin(emit);
      }
    } on SocketException {
      emit(
        LoginFail(error: NoInternetException('No Internet')),
      );
    } on HttpException {
      emit(
        LoginFail(error: NoServiceFoundException('No Service Found')),
      );
    } on FormatException {
      emit(
        LoginFail(error: InvalidFormatException('Invalid Response format')),
      );
    } catch (e) {
      _errorLogHelper.record(
          event.eventName(), event.eventParameters(), e.toString());
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  void _onSignOut(
    SignOut event,
    Emitter<LoginState> emit,
  ) async {
    print(event.toString());
    try {
      emit(LoadingUI());
      await loginRepos.signOut();
      emit(LoginInitState());
      memberBloc.add(UpdateSubscriptionType(
          isLogin: false, israfelId: null, subscriptionType: null));
    } on SocketException {
      emit(
        LoginFail(error: NoInternetException('No Internet')),
      );
    } on HttpException {
      emit(
        LoginFail(error: NoServiceFoundException('No Service Found')),
      );
    } on FormatException {
      emit(
        LoginFail(error: InvalidFormatException('Invalid Response format')),
      );
    } catch (e) {
      _errorLogHelper.record(
          event.eventName(), event.eventParameters(), e.toString());
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }
}
