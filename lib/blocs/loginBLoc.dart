import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/appleSignInService.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/services/facebookSignInService.dart';
import 'package:readr_app/services/googleSignInService.dart';
import 'package:readr_app/helpers/loginResponse.dart';
import 'package:readr_app/services/memberService.dart';

class LoginBloc {
  FirebaseAuth auth;

  String _routeName;
  Object _routeArguments;

  StreamController _loginController;
  StreamSink<LoginResponse<Member>> get loginSink =>
      _loginController.sink;
  Stream<LoginResponse<Member>> get loginStream =>
      _loginController.stream;

  LoginBloc(
    String routeName,
    Object routeArguments,
  ) {
    auth = FirebaseAuth.instance;
    _routeName = routeName;
    _routeArguments = routeArguments;

    _loginController = StreamController<LoginResponse<Member>>();

    renderingUI();
  }

  loginSinkToAdd(LoginResponse<Member> value) {
    if (!_loginController.isClosed) {
      loginSink.add(value);
    }
  }

  renderingUI() async{
    loginSinkToAdd(LoginResponse.loadingUI('Getting login token'));
    if(auth.currentUser == null) {
      loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
    } else {
      try {
        String token = await auth.currentUser.getIdToken();
        MemberService memberService = MemberService();
        Member member = await memberService.fetchMemberData(auth.currentUser.uid, token);
        loginSinkToAdd(LoginResponse.completed(member));
      } catch(e) {
        // fetch member fail
        print(e);
        loginSinkToAdd(LoginResponse.error(e.toString()));
      }
    }
  }

  renderingUIAfterEmailLogin(BuildContext context) async{
    loginSinkToAdd(LoginResponse.loadingUI('Getting login token'));
    if(auth.currentUser == null) {
      loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
    } else {
      try {
        String token = await auth.currentUser.getIdToken();
        MemberService memberService = MemberService();
        Member member = await memberService.fetchMemberData(auth.currentUser.uid, token);
        loginSinkToAdd(LoginResponse.completed(member));
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('登入成功')
          )
        );

        loginSinkToAdd(LoginResponse.completed(member));
        if(_routeName != RouteGenerator.member) {
          if(_routeName == RouteGenerator.story) {
            Navigator.of(context).popUntil(ModalRoute.withName(RouteGenerator.root));
          } else {
            Navigator.of(context).pop();
          }
          
          Navigator.of(context).pushNamed(
            _routeName,
            arguments: _routeArguments,
          );
        }
      } catch(e) {
        // fetch member fail
        print(e);
        loginSinkToAdd(LoginResponse.error(e.toString()));
      }
    }
  }

  void handleCreateMember(BuildContext context) async{
    MemberService memberService = MemberService();
    String token = await auth.currentUser.getIdToken();
    bool createSuccess = await memberService.createMember(auth.currentUser.email, auth.currentUser.uid, token);
    if(createSuccess) {
      try {
        Member member = await memberService.fetchMemberData(auth.currentUser.uid, token);

        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('登入成功')
          )
        );

        loginSinkToAdd(LoginResponse.completed(member));
        if(_routeName != RouteGenerator.member) {
          if(_routeName == RouteGenerator.story) {
            Navigator.of(context).popUntil(ModalRoute.withName(RouteGenerator.root));
          } else {
            Navigator.of(context).pop();
          }
          
          Navigator.of(context).pushNamed(
            _routeName,
            arguments: _routeArguments,
          );
        }
      } catch(e) {
        // fetch member fail
        print(e);
        loginSinkToAdd(LoginResponse.error(e.toString()));
      }
    } else {
      await auth.signOut();
      loginSinkToAdd(LoginResponse.loginError('Create member fail'));
    }
  }

  loginByFacebook(BuildContext context) async {
    loginSinkToAdd(LoginResponse.facebookLoading('Running facebook login'));

    try {
      FacebookSignInService facebookSignInService = FacebookSignInService();
      FirebaseLoginStatus frebaseLoginStatus = await facebookSignInService.signInWithFacebook(auth);

      if(frebaseLoginStatus.status == FirebaseStatus.Cancel) {
        loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
      } else if(frebaseLoginStatus.status == FirebaseStatus.Success) {
        handleCreateMember(context);
      } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
        loginSinkToAdd(LoginResponse.loginError('Firebase facebook login fail'));
      } 
    } catch (e) {
      loginSinkToAdd(LoginResponse.loginError(e.toString()));
      print(e);
    }
  }

  loginByGoogle(BuildContext context) async {
    loginSinkToAdd(LoginResponse.googleLoading('Running google login'));

    try {
      GoogleSignInService googleSignInService = GoogleSignInService();
      FirebaseLoginStatus frebaseLoginStatus = await googleSignInService.signInWithGoogle(auth);

      if(frebaseLoginStatus.status == FirebaseStatus.Cancel) {
        loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
      } else if(frebaseLoginStatus.status == FirebaseStatus.Success) {
        handleCreateMember(context);
      } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
        loginSinkToAdd(LoginResponse.loginError('Firebase google login fail'));
      } 
    } catch (e) {
      loginSinkToAdd(LoginResponse.loginError(e.toString()));
      print(e);
    }
  }

  loginByApple(BuildContext context) async {
    loginSinkToAdd(LoginResponse.appleLoading('Running apple login'));

    try {
      AppleSignInService appleSignInService = AppleSignInService();
      FirebaseLoginStatus frebaseLoginStatus = await appleSignInService.signInWithApple(auth);

      if(frebaseLoginStatus.status == FirebaseStatus.Cancel) {
        loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
      } else if(frebaseLoginStatus.status == FirebaseStatus.Success) {
        handleCreateMember(context);
      } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
        loginSinkToAdd(LoginResponse.loginError('Firebase apple login fail'));
      } 
    } catch (e) {
      loginSinkToAdd(LoginResponse.loginError(e.toString()));
      print(e);
    }
  }

  fetchSignInMethodsForEmail(BuildContext context, email) async {
    loginSinkToAdd(LoginResponse.fetchSignInMethodsForEmailLoading('Running fetch sign in methods for email'));

    try {
      EmailSignInServices emailSignInServices = EmailSignInServices();
      List<String> signInMethodsStringList = await emailSignInServices.fetchSignInMethodsForEmail(email);

      if (signInMethodsStringList.contains('emailPassword')) {
        // TODO: log in by email and password
        loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
      } else if(signInMethodsStringList.contains('emailLink')) {
        // TODO: go to reset email and password
        loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
      } else {
        await RouteGenerator.navigateToEmailRegistered(context, email: email);
        renderingUIAfterEmailLogin(context);
      }
    } catch (e) {
      loginSinkToAdd(LoginResponse.loginError(e.toString()));
      print(e);
    }
  }

  signOut() async{
    loginSinkToAdd(LoginResponse.loadingUI('Running sign out'));
    await auth.signOut();
    renderingUI();
  }

  dispose() {
    _loginController?.close();
  }
}