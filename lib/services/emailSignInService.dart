import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';

abstract class EmailSignInRepos {
  Future<List<String>> fetchSignInMethodsForEmail(String email);
  Future<FirebaseLoginStatus> createUserWithEmailAndPassword(String email, String password);
  Future<FirebaseLoginStatus> signInWithEmailAndPassword(String email, String password);
  Future<FirebaseLoginStatus> sendPasswordResetEmail(String email);
}

class EmailSignInServices implements EmailSignInRepos{
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    List<String> resultList = List<String>();
    try {
      resultList = await _auth.fetchSignInMethodsForEmail(email);
    } catch(onError) {
      print('Fetch sign in methods for email: $onError');
    }
    return resultList;
  }

  Future<FirebaseLoginStatus> createUserWithEmailAndPassword(String email, String password) async {
    try {
      // Once signed in, get the UserCredential
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch(onError) {
      print('Error create user with email and password: $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.code,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Create user with email and password: with firebase success',
    );
  }

  Future<FirebaseLoginStatus> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Once signed in, get the UserCredential
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch(onError) {
      print('Error sign in with email and password: $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.code,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Sign in with email and password: with firebase success',
    );
  }

  Future<FirebaseLoginStatus> sendPasswordResetEmail(String email) async {
    var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: env.baseConfig.finishSignUpUrl,
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: env.baseConfig.iOSBundleId,
      androidPackageName: env.baseConfig.androidPackageName,
      // installIfNotAvailable
      androidInstallApp: false,
      // minimumVersion
      androidMinimumVersion: "12",
      dynamicLinkDomain: env.baseConfig.dynamicLinkDomain,
    );

    try{
      await _auth.sendPasswordResetEmail(
        email: email, 
        actionCodeSettings: acs
      );
    } catch(onError) {
      print('Error sending password reset email $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.code,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Send password reset email: with firebase success',
    );
  }
}