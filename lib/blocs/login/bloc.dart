import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/data/providers/auth_info_provider.dart';
import 'package:readr_app/helpers/error_log_helper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/shared/premium_animate_page.dart';
import 'package:readr_app/services/login_service.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

enum LoginLoadingType { google, facebook, apple, email, anonymous }

class LoginBloc extends Bloc<LoginEvents, LoginState> with Logger {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MemberService _memberService = MemberService();
  final ErrorLogHelper _errorLogHelper = ErrorLogHelper();
  LoginLoadingType? _loginLoadingType;

  Future<void> _handleFirebaseThirdPartyLogin(
    FirebaseLoginStatus firebaseLoginStatus,
    Emitter<LoginState> emit,
  ) async {
    if (firebaseLoginStatus.status == FirebaseStatus.Cancel) {
      emit(LoginInitState());
    } else if (firebaseLoginStatus.status == FirebaseStatus.Success) {
      bool isNewUser = false;
      if (firebaseLoginStatus.message is UserCredential) {
        UserCredential userCredential = firebaseLoginStatus.message;
        isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      }
      await _handleCreateMember(isNewUser, emit);
    } else if (firebaseLoginStatus.status == FirebaseStatus.Error) {
      _errorLogHelper.record(
          Exception(
              '[HandleFirebaseThirdPartyLogin] status: ${firebaseLoginStatus.toString()}'),
          StackTrace.current);

      if (firebaseLoginStatus.message is FirebaseAuthException &&
          firebaseLoginStatus.message.code ==
              'account-exists-with-different-credential') {
        await _checkThirdPartyLoginEmail(firebaseLoginStatus, emit);
      } else {
        emit(LoginFail(
          error: UnknownException(firebaseLoginStatus.message),
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
      debugLog('CreateMember');
      String? token = await _auth.currentUser!.getIdToken();
      if (token != null) {
        createSuccess = await _memberService.createMember(
            _auth.currentUser!.email, _auth.currentUser!.uid, token);
        if (createSuccess) {
          await _fetchMemberSubscriptionTypeToLogin(emit);
        } else {
          try {
            await _auth.currentUser!.delete();
          } catch (e) {
            debugLog(e);
            await _auth.signOut();
          }

          _errorLogHelper.record(
              Exception(
                  '[HandleCreateMember] Create member fail, isNewUser: $isNewUser'),
              StackTrace.current);

          emit(LoginFail(
            error: UnknownException('Create member fail'),
          ));
        }
      }
    }
  }

  Future<void> _checkThirdPartyLoginEmail(
    FirebaseLoginStatus firebaseLoginStatus,
    Emitter<LoginState> emit,
  ) async {
    try {
      String email = firebaseLoginStatus.message.email;
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
        emit(LoginFail(error: UnknownException(firebaseLoginStatus.message)));
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
    MemberIdAndSubscriptionType? memberIdAndSubscriptionType =
        await _memberService.checkSubscriptionType(_auth.currentUser!);
    if (memberIdAndSubscriptionType != null &&
        premiumSubscriptionType
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
        israfelId: memberIdAndSubscriptionType!.israfelId!,
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

    try {} catch (e, s) {
      // fetch member subscrition type fail
      debugLog(e.toString());

      _errorLogHelper.record(e, s);

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
    if (premiumSubscriptionType.contains(subscriptionType)) {
      await runPremiumAnimation();
    }

    if (routeName != null) {
      if (routeArguments != null &&
          routeArguments!.containsKey('subscriptionType')) {
        routeArguments!.update('subscriptionType', (value) => subscriptionType);
      }

      if (premiumSubscriptionType.contains(subscriptionType)) {
        // await premium animation pop completed
        await Future.delayed(const Duration(seconds: 1));
      }

      if (routeName == RouteGenerator.subscriptionSelect) {
        RouteGenerator.navigatorKey.currentState!.pop();
      } else {
        RouteGenerator.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          routeName!,
          ModalRoute.withName(RouteGenerator.root),
          arguments: routeArguments,
        );
      }
    }
  }

  void _onCheckIsLoginOrNot(
    CheckIsLoginOrNot event,
    Emitter<LoginState> emit,
  ) async {
    debugLog(event.toString());

    if (_auth.currentUser == null) {
      emit(LoginInitState());
    } else {
      MemberIdAndSubscriptionType? memberIdAndSubscriptionType =
          await _memberService.checkSubscriptionType(_auth.currentUser!);
      final AuthInfoProvider authInfoProvider = Get.find();

      try {
        if (memberIdAndSubscriptionType != null) {
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
                  .contains(memberIdAndSubscriptionType.subscriptionType) &&
              authInfoProvider.rxnLoginType.value != LoginType.anonymous) {
            await runPremiumAnimation();
          }
        }
      } catch (e, s) {
        // there is no member in israfel
        if (e.toString() == "Invalid Request: $memberStateTypeIsNotFound") {
          try {
            await _auth.currentUser!.delete();
          } catch (e) {
            debugLog(e);
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

        _errorLogHelper.record(e, s);
        debugLog(e.toString());
        emit(LoginFail(
            error: UnknownException('Fetch member subscrition type fail')));
      }
    }
  }

  void _signInWithGoogle(
    SignInWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    debugLog(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.google;
      emit(LoginLoading(loginType: LoginType.google));
      FirebaseLoginStatus firebaseLoginStatus =
          await loginRepos.signInWithGoogle();
      await _handleFirebaseThirdPartyLogin(
        firebaseLoginStatus,
        emit,
      );
      _signInTransition();
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
    } catch (e, s) {
      _errorLogHelper.record(e, s);
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  void _signInWithFacebook(
    SignInWithFacebook event,
    Emitter<LoginState> emit,
  ) async {
    debugLog(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.facebook;
      emit(LoginLoading(loginType: LoginType.facebook));
      FirebaseLoginStatus firebaseLoginStatus =
          await loginRepos.signInWithFacebook();
      await _handleFirebaseThirdPartyLogin(
        firebaseLoginStatus,
        emit,
      );
      _signInTransition();
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
    } catch (e, s) {
      _errorLogHelper.record(e, s);
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  void _signInWithApple(
    SignInWithApple event,
    Emitter<LoginState> emit,
  ) async {
    debugLog(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.apple;
      emit(LoginLoading(loginType: LoginType.apple));
      FirebaseLoginStatus firebaseLoginStatus =
          await loginRepos.signInWithApple();
      await _handleFirebaseThirdPartyLogin(
        firebaseLoginStatus,
        emit,
      );
      _signInTransition();
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
    } catch (e, s) {
      _errorLogHelper.record(e, s);
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  void _signInTransition() async {
    MemberIdAndSubscriptionType? memberIdAndSubscriptionType =
        await _memberService.checkSubscriptionType(_auth.currentUser!);
    if (memberIdAndSubscriptionType != null &&
        premiumSubscriptionType
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
        israfelId: memberIdAndSubscriptionType!.israfelId!,
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
  }

  // need to refactor route
  void _fetchSignInMethodsForEmail(
    FetchSignInMethodsForEmail event,
    Emitter<LoginState> emit,
  ) async {
    debugLog(event.toString());
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
    } catch (e, s) {
      _errorLogHelper.record(e, s);
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }

  void _onSignOut(
    SignOut event,
    Emitter<LoginState> emit,
  ) async {
    debugLog(event.toString());
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
    } catch (e, s) {
      _errorLogHelper.record(e, s);
      emit(
        LoginFail(error: UnknownException(e.toString())),
      );
    }
  }
}
