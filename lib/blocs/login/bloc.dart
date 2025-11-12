import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/error_log_helper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/models/sign_in_method_status.dart';
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
    on<CheckEmailSignInMethod>(_checkEmailSignInMethod);
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
      SignInMethodStatus status = await loginRepos.checkSignInMethod(email);

      if (status == SignInMethodStatus.password) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByPasswordMethodWarningMessage));
      } else if (status == SignInMethodStatus.thirdParty) {
        emit(RegisteredByAnotherMethod(
            warningMessage: registeredByThirdPartyMethodWarningMessage));
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
        emit(CheckEmailSignInMethodLoading());
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
      memberIdAndSubscriptionType ??= MemberIdAndSubscriptionType(
        israfelId: null,
        subscriptionType: SubscriptionType.none,
        isNewebpay: false,
      );

      emit(LoginSuccess(
        israfelId: memberIdAndSubscriptionType.israfelId ?? '',
        subscriptionType: memberIdAndSubscriptionType.subscriptionType ??
            SubscriptionType.none,
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
    _navigateToRouteName(
        memberIdAndSubscriptionType.subscriptionType ?? SubscriptionType.none);

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
    if (_auth.currentUser == null) {
      emit(LoginInitState());
    } else {
      MemberIdAndSubscriptionType? memberIdAndSubscriptionType =
          await _memberService.checkSubscriptionType(_auth.currentUser!);

      if (memberIdAndSubscriptionType == null) {
        // 當 memberIdAndSubscriptionType 為 null 時，提供默認值而不是停留在 Loading 狀態
        memberIdAndSubscriptionType = MemberIdAndSubscriptionType(
          israfelId: null,
          subscriptionType: SubscriptionType.none,
          isNewebpay: false,
        );
      }

      try {
        memberBloc.add(UpdateSubscriptionType(
            isLogin: true,
            israfelId: memberIdAndSubscriptionType.israfelId,
            subscriptionType: memberIdAndSubscriptionType.subscriptionType));

        // CheckIsLoginOrNot 不應該播放動畫，只有真正登入時才播放
        emit(LoginSuccess(
          israfelId: memberIdAndSubscriptionType.israfelId ?? '',
          subscriptionType: memberIdAndSubscriptionType.subscriptionType ??
              SubscriptionType.none,
          isNewebpay: memberIdAndSubscriptionType.isNewebpay,
        ));
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
      await _signInTransition();
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
      await _signInTransition();
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
      await _signInTransition();
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

  Future<void> _signInTransition() async {
    MemberIdAndSubscriptionType? memberIdAndSubscriptionType =
        await _memberService.checkSubscriptionType(_auth.currentUser!);

    if (memberIdAndSubscriptionType != null &&
        premiumSubscriptionType
            .contains(memberIdAndSubscriptionType.subscriptionType)) {
      if (_loginLoadingType == LoginLoadingType.email) {
        emit(CheckEmailSignInMethodLoading());
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
      // 如果 memberIdAndSubscriptionType 是 null，提供默認值
      if (memberIdAndSubscriptionType == null) {
        memberIdAndSubscriptionType = MemberIdAndSubscriptionType(
          israfelId: null,
          subscriptionType: SubscriptionType.none,
          isNewebpay: false,
        );
      }
      emit(LoginSuccess(
        israfelId: memberIdAndSubscriptionType.israfelId ?? '',
        subscriptionType: memberIdAndSubscriptionType.subscriptionType ??
            SubscriptionType.none,
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
    _navigateToRouteName(
        memberIdAndSubscriptionType.subscriptionType ?? SubscriptionType.none);
  }

  // need to refactor route
  void _checkEmailSignInMethod(
    CheckEmailSignInMethod event,
    Emitter<LoginState> emit,
  ) async {
    debugLog(event.toString());
    try {
      _loginLoadingType = LoginLoadingType.email;
      emit(CheckEmailSignInMethodLoading());
      SignInMethodStatus status =
          await loginRepos.checkSignInMethod(event.email);

      switch (status) {
        case SignInMethodStatus.password:
          await RouteGenerator.navigateToEmailLogin(email: event.email);
          await _renderingUiAfterEmailLogin(emit);
          break;
        case SignInMethodStatus.notRegistered:
          await RouteGenerator.navigateToEmailRegistered(email: event.email);
          await _renderingUiAfterEmailLogin(emit);
          break;
        case SignInMethodStatus.thirdParty:
          emit(RegisteredByAnotherMethod(
              warningMessage: registeredByThirdPartyMethodWarningMessage));
          _loginLoadingType = null;
          return;
        case SignInMethodStatus.unknown:
          emit(
            LoginFail(
              error: UnknownException(
                  'CheckEmailSignInMethod failed for ${event.email}'),
            ),
          );
          break;
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
