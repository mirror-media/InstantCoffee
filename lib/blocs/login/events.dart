import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/loginService.dart';
import 'package:readr_app/services/memberService.dart';

abstract class LoginEvents{
  Stream<LoginState> run(
    LoginRepos loginRepos,
    String routeName,
    Object routeArguments,
  );
  Stream<LoginState> handleFirebaseLogin(
    BuildContext context,
    String routeName,
    Object routeArguments,
    FirebaseLoginStatus frebaseLoginStatus
  ) async*{ 
    if(frebaseLoginStatus.status == FirebaseStatus.Cancel) {
      yield LoginInitState();
    } else if(frebaseLoginStatus.status == FirebaseStatus.Success) {
      yield* handleCreateMember(context, routeName, routeArguments);
    } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
      yield LoginFail(
        error: UnknownException(frebaseLoginStatus.message),
      );
    } 
  }
  Stream<LoginState> handleCreateMember(
    BuildContext context,
    String routeName,
    Object routeArguments,
  ) async*{
    FirebaseAuth auth = FirebaseAuth.instance;
    MemberService memberService = MemberService();
    String token = await auth.currentUser.getIdToken();
    bool createSuccess = await memberService.createMember(
      auth.currentUser.email, 
      auth.currentUser.uid, 
      token
    );
    
    if(createSuccess) {
      yield* fetchMemberToLogin(
        auth,
        context,
        routeName,
        routeArguments,
      );
    } else {
      await auth.signOut();
      LoginFail(
        error: UnknownException('Create member fail'),
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
      Member member = await memberService.fetchMemberData(auth.currentUser.uid, token);
      yield LoginSuccess(
        member: member,
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
      LoginFail(
        error: UnknownException('Fetch member fail'),
      );
    }
  }
  navigateToRouteName(
    BuildContext context,
    String routeName,
    Object routeArguments,
  ) {
    if(routeName != RouteGenerator.member) {
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
        Member member = await memberService.fetchMemberData(_auth.currentUser.uid, token);
        yield LoginSuccess(
          member: member,
        );
      } catch(e) {
        // fetch member fail
        print(e.toString());
        LoginFail(
          error: UnknownException('Fetch member fail'),
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
      yield* handleFirebaseLogin(
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
      yield* handleFirebaseLogin(
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
      yield* handleFirebaseLogin(
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
  String toString() => 'SignInWithApple';

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

      if (signInMethodsStringList.contains('password')) {
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