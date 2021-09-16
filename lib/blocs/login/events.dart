import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/services/loginService.dart';
import 'package:readr_app/services/memberService.dart';

final String registeredByGoogleMethodWarningMessage = '由於您曾以Google帳號登入，請點擊上方「使用 Google 登入」重試。';
final String registeredByFacebookMethodWarningMessage = '由於您曾以Facebook帳號登入，請點擊上方「使用 Facebook 登入」重試。';
final String registeredByAppleMethodWarningMessage = '由於您曾以Apple帳號登入，請點擊上方「使用 Apple 登入」重試。';
final String registeredByPasswordMethodWarningMessage = '由於您曾以email帳號密碼登入，請輸入下方email重試。';

abstract class LoginEvents{
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  );

  Stream<LoginState> handleFirebaseThirdPartyLogin(
    BuildContext context,
    String routeName,
    Object routeArguments,
    FirebaseLoginStatus frebaseLoginStatus
  ) async*{ 
    if(frebaseLoginStatus.status == FirebaseStatus.Cancel) {
      yield LoginInitState();
    } else if(frebaseLoginStatus.status == FirebaseStatus.Success) {
      bool isNewUser = false;
      if(frebaseLoginStatus.message is UserCredential) {
        UserCredential userCredential = frebaseLoginStatus.message;
        if(userCredential.additionalUserInfo != null) {
          isNewUser = userCredential.additionalUserInfo.isNewUser;
        }
      }
      yield* handleCreateMember(context, isNewUser, routeName, routeArguments);
    } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
      if(frebaseLoginStatus.message is FirebaseAuthException &&
        frebaseLoginStatus.message.code == 'account-exists-with-different-credential') {
        yield* checkThirdPartyLoginEmail(frebaseLoginStatus);
      } else {
        yield LoginFail(
          error: UnknownException(frebaseLoginStatus.message),
        );
      }
    } 
  }

  Stream<LoginState> handleCreateMember(
    BuildContext context,
    bool isNewUser,
    String routeName,
    Object routeArguments,
  ) async*{
    FirebaseAuth auth = FirebaseAuth.instance;
    String token = await auth.currentUser.getIdToken();
    bool createSuccess = true;

    if(isNewUser) {
      MemberService memberService = MemberService();
      print('CreateMember');
      createSuccess = await memberService.createMember(
        auth.currentUser.email,
        token
      );
    }

    if(createSuccess) {
      yield* fetchMemberToLogin(
        auth,
        context,
        routeName,
        routeArguments,
      );
    } else {
      await auth.signOut();
      yield LoginFail(
        error: UnknownException('Create member fail'),
      );
    }
  }

  Stream<LoginState> checkThirdPartyLoginEmail(
    FirebaseLoginStatus frebaseLoginStatus
  ) async*{
    try{
      String email = frebaseLoginStatus.message.email;
      List<String> signInMethodsStringList = await LoginServices().fetchSignInMethodsForEmail(email);

      if(signInMethodsStringList.contains('google.com')) {
        yield RegisteredByAnotherMethod(warningMessage: registeredByGoogleMethodWarningMessage);
      } else if(signInMethodsStringList.contains('facebook.com')) {
        yield RegisteredByAnotherMethod(warningMessage: registeredByFacebookMethodWarningMessage);
      } else if(signInMethodsStringList.contains('apple.com')) {
        yield RegisteredByAnotherMethod(warningMessage: registeredByAppleMethodWarningMessage);
      } else if (signInMethodsStringList.contains('password')) {
        yield RegisteredByAnotherMethod(warningMessage: registeredByPasswordMethodWarningMessage);
      } else {
        yield LoginFail(
          error: UnknownException(frebaseLoginStatus.message),
        );
      }
    } on SocketException {
      yield LoginFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield LoginFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield LoginFail(
        error: UnknownException(e.toString()),
      );
    }
  }

  Stream<LoginState> renderingUIAfterEmailLogin(
    BuildContext context,
    String routeName,
    Object routeArguments,
  ) async*{
    FirebaseAuth auth = FirebaseAuth.instance;

    if(auth.currentUser == null) {
      yield LoginInitState();
    } else {
      yield* fetchMemberToLogin(
        auth,
        context,
        routeName,
        routeArguments,
      );
    }
  }

  Stream<LoginState> fetchMemberToLogin(
    FirebaseAuth auth,
    BuildContext context,
    String routeName,
    Object routeArguments,
  ) async*{
    try {
      String token = await auth.currentUser.getIdToken();
      MemberService memberService = MemberService();
      MemberIdAndSubscritionType memberIdAndSubscritionType = await memberService.checkSubscriptionType(auth.currentUser.uid, token);
      yield LoginSuccess(
        israfelId: memberIdAndSubscritionType.israfelId,
        subscritionType: memberIdAndSubscritionType.subscritionType
      );
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('登入成功')
        )
      );
      navigateToRouteName(
        context,
        routeName,
        routeArguments,
      );
    } catch(e) {
      // fetch member fail
      print(e.toString());
      yield LoginFail(
        error: UnknownException('Fetch member subscrition type fail'),
      );
    }
  }

  navigateToRouteName(
    BuildContext context,
    String routeName,
    Object routeArguments,
  ) {
    if(routeName != RouteGenerator.login) {
      if(routeName == RouteGenerator.story) {
        Navigator.of(context).popUntil(ModalRoute.withName(RouteGenerator.root));
      } else {
        Navigator.of(context).pop();
      }
      
      Navigator.of(context).pushNamed(
        routeName,
        arguments: routeArguments,
      );
    }
  }
}

class CheckIsLoginOrNot extends LoginEvents {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  String toString() => 'CheckIsLoginOrNot';

  @override
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  ) async*{
    print(this.toString());
    if(_auth.currentUser == null) {
      yield LoginInitState();
    } else {
      try {
        String token = await _auth.currentUser.getIdToken();
        MemberService memberService = MemberService();
        MemberIdAndSubscritionType memberIdAndSubscritionType = await memberService.checkSubscriptionType(_auth.currentUser.uid, token);
        yield LoginSuccess(
          israfelId: memberIdAndSubscritionType.israfelId,
          subscritionType: memberIdAndSubscritionType.subscritionType
        );
      } catch(e) {
        // fetch member subscrition type fail
        // _auth.signOut();
        print(e.toString());
        yield LoginFail(
          error: UnknownException('Fetch member subscrition type fail'),
        );
      }
    }
  }
}

class SignInWithGoogle extends LoginEvents {
  final BuildContext context;
  SignInWithGoogle(
    this.context,
  );
  
  @override
  String toString() => 'SignInWithGoogle';

  @override
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  ) async*{
    print(this.toString());
    try{
      yield GoogleLoading();
      FirebaseLoginStatus frebaseLoginStatus = await loginRepos.signInWithGoogle();
      yield* handleFirebaseThirdPartyLogin(
        context, 
        routeName, 
        routeArguments,
        frebaseLoginStatus,
      );
    } on SocketException {
      yield LoginFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield LoginFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield LoginFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class SignInWithFacebook extends LoginEvents {
  final BuildContext context;
  SignInWithFacebook(
    this.context,
  );
  
  @override
  String toString() => 'SignInWithFacebook';

  @override
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  ) async*{
    print(this.toString());
    try{
      yield FacebookLoading();
      FirebaseLoginStatus frebaseLoginStatus = await loginRepos.signInWithFacebook();
      yield* handleFirebaseThirdPartyLogin(
        context, 
        routeName, 
        routeArguments,
        frebaseLoginStatus,
      );
    } on SocketException {
      yield LoginFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield LoginFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield LoginFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class SignInWithApple extends LoginEvents {
  final BuildContext context;
  SignInWithApple(
    this.context,
  );
  
  @override
  String toString() => 'SignInWithApple';

  @override
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  ) async*{
    print(this.toString());
    try{
      yield AppleLoading();
      FirebaseLoginStatus frebaseLoginStatus = await loginRepos.signInWithApple();
      yield* handleFirebaseThirdPartyLogin(
        context, 
        routeName, 
        routeArguments,
        frebaseLoginStatus,
      );
    } on SocketException {
      yield LoginFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield LoginFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield LoginFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class FetchSignInMethodsForEmail extends LoginEvents {
  final BuildContext context;
  final String email;
  FetchSignInMethodsForEmail(
    this.context,
    this.email,
  );
  
  @override
  String toString() => 'FetchSignInMethodsForEmail';

  @override
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  ) async*{
    print(this.toString());
    try{
      yield FetchSignInMethodsForEmailLoading();
      List<String> signInMethodsStringList = await loginRepos.fetchSignInMethodsForEmail(email);

      if(signInMethodsStringList.length == 1 && signInMethodsStringList.contains('google.com')) {
        yield RegisteredByAnotherMethod(warningMessage: registeredByGoogleMethodWarningMessage);
      } else if(signInMethodsStringList.length == 1 && signInMethodsStringList.contains('facebook.com')) {
        yield RegisteredByAnotherMethod(warningMessage: registeredByFacebookMethodWarningMessage);
      } else if(signInMethodsStringList.length == 1 && signInMethodsStringList.contains('apple.com')) {
        yield RegisteredByAnotherMethod(warningMessage: registeredByAppleMethodWarningMessage);
      } else if (signInMethodsStringList.contains('password')) {
        await RouteGenerator.navigateToEmailLogin(context, email: email);
        yield* renderingUIAfterEmailLogin(
          context,
          routeName,
          routeArguments,
        );
      } else if(signInMethodsStringList.contains('emailLink')) {
        await RouteGenerator.navigateToPasswordResetPrompt(context, email: email);
        yield* renderingUIAfterEmailLogin(
          context,
          routeName,
          routeArguments,
        );
      } else {
        await RouteGenerator.navigateToEmailRegistered(context, email: email);
        yield* renderingUIAfterEmailLogin(
          context,
          routeName,
          routeArguments,
        );
      }
    } on SocketException {
      yield LoginFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield LoginFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield LoginFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class SignOut extends LoginEvents {
  @override
  String toString() => 'SignOut';

  @override
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  ) async*{
    print(this.toString());
    try{
      yield LoadingUI();
      await loginRepos.signOut();
      yield LoginInitState();
    } on SocketException {
      yield LoginFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield LoginFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield LoginFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}