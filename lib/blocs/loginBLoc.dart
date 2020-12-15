import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/userData.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/services/googleSignInService.dart';
import 'package:readr_app/helpers/loginResponse.dart';

class LoginBloc {
  FirebaseAuth auth;

  StreamController _loginController;
  StreamSink<LoginResponse<UserData>> get loginSink =>
      _loginController.sink;
  Stream<LoginResponse<UserData>> get loginStream =>
      _loginController.stream;

  LoginBloc(bool isEmailLoginAuth, String emailLink) {
    auth = FirebaseAuth.instance;
    _loginController = StreamController<LoginResponse<UserData>>();
    if(!isEmailLoginAuth) {
      renderingUI();
    } else {
      renderingEmailLoginAuthUI(emailLink);
    }
  }

  loginSinkToAdd(LoginResponse<UserData> value) {
    if (!_loginController.isClosed) {
      loginSink.add(value);
    }
  }

  renderingUI() {
    loginSinkToAdd(LoginResponse.loadingUI('Getting login token'));
    if(auth.currentUser == null) {
      loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
    } else {
      UserData userData = getUserDate();
      loginSinkToAdd(LoginResponse.completed(userData));
    }
  }

  renderingEmailLoginAuthUI(String emailLink) async{
    final storage = FlutterSecureStorage();
    String email = await storage.read(key: 'email');
    if(email != null) {
      loginSinkToAdd(LoginResponse.emailLoading('Verify email login'));
      await verifyEmail(email, emailLink);
      await storage.delete(key: 'email');
    } else {
      UserData userData = UserData(verifyEmailLink: emailLink);
      loginSinkToAdd(LoginResponse.emailFillingIn(userData));
    }
  }

  Future<void> verifyEmail(email, emailLink) async{
    EmailSignInService emailSignInService = EmailSignInService();
    FirebaseLoginStatus firebaseLoginStatus = await emailSignInService.verifyEmail(auth, email, emailLink);
    if(firebaseLoginStatus.status == FirebaseStatus.Success) {
      UserData userData = getUserDate();
      loginSinkToAdd(LoginResponse.completed(userData));
    } else {
      loginSinkToAdd(LoginResponse.error('Verify email fail'));
    }
  }

  UserData getUserDate() {
    return UserData(
      email: auth.currentUser.email,
      name: auth.currentUser.displayName,
      profilePhoto: auth.currentUser.photoURL,
    );
  }

  loginByGoogle(BuildContext context) async {
    loginSinkToAdd(LoginResponse.googleLoading('Running google login'));

    try {
      GoogleSignInService googleSignInService = GoogleSignInService();
      FirebaseLoginStatus frebaseLoginStatus = await googleSignInService.signInWithGoogle(auth);

      if(frebaseLoginStatus.status == FirebaseStatus.Cancel) {
        loginSinkToAdd(LoginResponse.needToLogin('Waiting for login'));
      } else if(frebaseLoginStatus.status == FirebaseStatus.Success) {
        UserData userData = getUserDate();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${userData.name} 登入成功')
          )
        );
        loginSinkToAdd(LoginResponse.completed(userData));
      } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
        loginSinkToAdd(LoginResponse.error('Firebase google login fail'));
      } 
    } catch (e) {
      loginSinkToAdd(LoginResponse.error(e.toString()));
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
        UserData userData = UserData(
          email: email,
        );

        loginSinkToAdd(LoginResponse.emailLinkGetting(userData));
      } else {
        loginSinkToAdd(LoginResponse.error('Firebase sending email fail'));
      }
    } catch (e) {
      loginSinkToAdd(LoginResponse.error(e.toString()));
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