import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/userData.dart';
import 'package:readr_app/services/googleSignInService.dart';
import 'package:readr_app/helpers/loginResponse.dart';

class LoginBloc {
  FirebaseAuth auth;

  StreamController _loginController;
  StreamSink<LoginResponse<UserData>> get loginSink =>
      _loginController.sink;
  Stream<LoginResponse<UserData>> get loginStream =>
      _loginController.stream;

  LoginBloc() {
    auth = FirebaseAuth.instance;
    _loginController = StreamController<LoginResponse<UserData>>();
    renderingUI();
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

  UserData getUserDate() {
    return UserData(
      email: auth.currentUser.email,
      name: auth.currentUser.displayName,
      profilePhoto: auth.currentUser.photoURL,
      phoneNumber: auth.currentUser.phoneNumber,
      gender: Gender.Null,
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

  signOut() async{
    loginSinkToAdd(LoginResponse.loadingUI('Running sign out'));
    await auth.signOut();
    renderingUI();
  }

  dispose() {
    _loginController?.close();
  }
}