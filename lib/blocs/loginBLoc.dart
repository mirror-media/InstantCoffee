import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/services/facebookSignInService.dart';
import 'package:readr_app/services/googleSignInService.dart';
import 'package:readr_app/helpers/loginResponse.dart';
import 'package:readr_app/services/memberService.dart';

class LoginBloc {
  FirebaseAuth auth;

  String _emailLink;

  StreamController _loginController;
  StreamSink<LoginResponse<Member>> get loginSink =>
      _loginController.sink;
  Stream<LoginResponse<Member>> get loginStream =>
      _loginController.stream;

  LoginBloc(
    bool isEmailLoginAuth,
    String emailLink,
  ) {
    auth = FirebaseAuth.instance;
    _emailLink = emailLink;

    _loginController = StreamController<LoginResponse<Member>>();

    if(!isEmailLoginAuth) {
      renderingUI();
    } else {
      renderingEmailLoginAuthUI();
    }
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

  renderingEmailLoginAuthUI() async{
    final storage = FlutterSecureStorage();
    String email = await storage.read(key: 'email');
    if(email != null) {
      loginSinkToAdd(LoginResponse.verifyEmailLoading('Verify email login'));
    } else {
      loginSinkToAdd(LoginResponse.emailFillingIn('need to fill in email'));
    }
  }

  Future<void> verifyEmail(BuildContext context) async{
    final storage = FlutterSecureStorage();
    String email = await storage.read(key: 'email');
    EmailSignInService emailSignInService = EmailSignInService();
    FirebaseLoginStatus firebaseLoginStatus = await emailSignInService.verifyEmail(auth, email, _emailLink);
    if(firebaseLoginStatus.status == FirebaseStatus.Success) {
      handleCreateMember(context);
    } else {
      loginSinkToAdd(LoginResponse.loginError('Verify email fail'));
    }
    await storage.delete(key: 'email');
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

  loginByEmail(String email) async {
    loginSinkToAdd(LoginResponse.emailLoading('Running email login'));

    try {
      EmailSignInService emailSignInService = EmailSignInService();
      bool isSentSuccessfully = await emailSignInService.sendSignInLinkToEmail(auth, email);

      if(isSentSuccessfully) {
        final storage = FlutterSecureStorage();
        await storage.write(key: 'email', value: email);
        Member member = Member(
          email: email,
        );

        loginSinkToAdd(LoginResponse.emailLinkGetting(member));
      } else {
        loginSinkToAdd(LoginResponse.loginError('Firebase sending email fail'));
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