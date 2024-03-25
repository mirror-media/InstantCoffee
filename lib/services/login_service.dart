import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class LoginRepos {
  Future<FirebaseLoginStatus> signInWithGoogle();
  Future<FirebaseLoginStatus> signInWithFacebook();
  Future<FirebaseLoginStatus> signInWithApple();
  Future<List<String>> fetchSignInMethodsForEmail(String email);
  Future<void> signOut();
}

class LoginServices with Logger implements LoginRepos {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<FirebaseLoginStatus> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return FirebaseLoginStatus(
        status: FirebaseStatus.Cancel,
        message: 'Google sign in cancel',
      );
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential;
    try {
      // Once signed in, get the UserCredential
      userCredential = await _auth.signInWithCredential(credential);
    } catch (onError) {
      debugLog('Error sign in with google $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: userCredential,
    );
  }

  @override
  Future<FirebaseLoginStatus> signInWithFacebook() async {
    // Trigger the authentication flow
    final LoginResult facebookUser = await FacebookAuth.instance.login();

    UserCredential userCredential;

    switch (facebookUser.status) {
      case LoginStatus.success:
        // Obtain the auth details from the request
        final AccessToken facebookAuth = facebookUser.accessToken!;

        // Create a new credential
        final OAuthCredential credential = FacebookAuthProvider.credential(
          facebookAuth.token,
        );

        try {
          // Once signed in, get the UserCredential
          userCredential = await _auth.signInWithCredential(credential);
          // Need to log out to avoid facebook login error 304
          await FacebookAuth.instance.logOut();
        } catch (onError) {
          debugLog('Error sign in with facebook $onError');
          // Need to log out to avoid facebook login error 304
          await FacebookAuth.instance.logOut();
          return FirebaseLoginStatus(
            status: FirebaseStatus.Error,
            message: onError,
          );
        }
        break;
      case LoginStatus.cancelled:
        return FirebaseLoginStatus(
          status: FirebaseStatus.Cancel,
          message: 'Facebook sign in cancel',
        );
      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        return FirebaseLoginStatus(
          status: FirebaseStatus.Error,
          message: facebookUser.message,
        );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: userCredential,
    );
  }

  // https://stackoverflow.com/questions/62805312/android-sign-in-with-apple-and-firebase-flutter
  // need a backend server to support apple sign in on android
  // but we don't support apple sign in on android in this app
  @override
  Future<FirebaseLoginStatus> signInWithApple() async {
    OAuthCredential oauthCredential;
    // Trigger the authentication flow
    try {
      AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
      );
    } catch (onError) {
      if (onError is SignInWithAppleAuthorizationException) {
        if (onError.code == AuthorizationErrorCode.canceled) {
          return FirebaseLoginStatus(
            status: FirebaseStatus.Cancel,
            message: 'Apple sign in cancel',
          );
        }
      }

      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError,
      );
    }

    UserCredential userCredential;
    try {
      // Once signed in, get the UserCredential
      userCredential = await _auth.signInWithCredential(oauthCredential);
    } catch (onError) {
      debugLog('Error sign in with apple $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: userCredential,
    );
  }

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    List<String> resultList = [];
    try {
      resultList = await _auth.fetchSignInMethodsForEmail(email);
    } catch (onError) {
      debugLog('Fetch sign in methods for email: $onError');
    }
    return resultList;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().disconnect();
  }

  static bool checkIsEmailAndPasswordLogin() {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return false;
    }

    for (int i = 0; i < auth.currentUser!.providerData.length; i++) {
      UserInfo userInfo = auth.currentUser!.providerData[i];
      if (userInfo.providerId == 'password') {
        return true;
      }
    }

    return false;
  }
}
