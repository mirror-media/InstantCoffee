
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class LoginRepos {
  Future<FirebaseLoginStatus> signInWithGoogle();
  Future<FirebaseLoginStatus> signInWithFacebook();
  Future<FirebaseLoginStatus> signInWithApple();
}

class LoginServices implements LoginRepos{
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<FirebaseLoginStatus> signInWithGoogle() async{
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if(googleUser == null) {
      return FirebaseLoginStatus(
        status: FirebaseStatus.Cancel,
        message: 'Google sign in cancel',
      );
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      // Once signed in, get the UserCredential
      await _auth.signInWithCredential(credential);
    } catch(onError) {
      print('Error sign in with google $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.toString(),
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Google sign in with firebase success',
    );
  }

  @override
  Future<FirebaseLoginStatus> signInWithFacebook() async{
    final FacebookLogin facebookSignIn = FacebookLogin();
    // Trigger the authentication flow
    FacebookLoginResult facebookUser = await facebookSignIn.logIn(['email']);

    switch (facebookUser.status) {
      case FacebookLoginStatus.loggedIn:
        // Obtain the auth details from the request
        final FacebookAccessToken facebookAuth = facebookUser.accessToken;

        // Create a new credential
        final FacebookAuthCredential credential = FacebookAuthProvider.credential(
          facebookAuth.token,
        );

        try {
          // Once signed in, get the UserCredential
          await _auth.signInWithCredential(credential);
        } catch(onError) {
          print('Error sign in with facebook $onError');
          return FirebaseLoginStatus(
            status: FirebaseStatus.Error,
            message: onError.toString(),
          );
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        return FirebaseLoginStatus(
          status: FirebaseStatus.Cancel,
          message: 'Facebook sign in cancel',
        );
        break;
      case FacebookLoginStatus.error:
        return FirebaseLoginStatus(
          status: FirebaseStatus.Error,
          message: facebookUser.errorMessage,
        );
        break;
    }
    
    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Facebook sign in with firebase success',
    );
  }

  // https://stackoverflow.com/questions/62805312/android-sign-in-with-apple-and-firebase-flutter
  // need a backend server to support apple sign in on android
  // but we don't support apple sign in on android in this app
  Future<FirebaseLoginStatus> signInWithApple() async {
    OAuthCredential oauthCredential;
    // Trigger the authentication flow
    try {
      AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
      );
    } catch (e) {
      if(e.code == AuthorizationErrorCode.canceled) {
        return FirebaseLoginStatus(
          status: FirebaseStatus.Cancel,
          message: 'Apple sign in cancel',
        );
      }
    }

    try {
      // Once signed in, get the UserCredential
      await _auth.signInWithCredential(oauthCredential);
    } catch(onError) {
      print('Error sign in with apple $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.toString(),
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Apple sign in with firebase success',
    );
  }
}