import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readr_app/helpers/crypto_utils.dart' as crypto_helper;
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/models/sign_in_method_status.dart';
import 'package:readr_app/services/email_sign_in_service.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class LoginRepos {
  Future<FirebaseLoginStatus> signInWithGoogle();
  Future<FirebaseLoginStatus> signInWithFacebook();
  Future<FirebaseLoginStatus> signInWithApple();
  Future<SignInMethodStatus> checkSignInMethod(String email);
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
    UserCredential? userCredential;
    String? rawNonce;

    try {
      if (Platform.isIOS) {
        await Permission.appTrackingTransparency.request();
      }

      rawNonce = crypto_helper.generateNonce();
      final hashedNonce = crypto_helper.sha256OfString(rawNonce);

      final LoginResult facebookLoginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        nonce: hashedNonce,
      );

      if (facebookLoginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = facebookLoginResult.accessToken;
        if (accessToken == null) {
          return FirebaseLoginStatus(
              status: FirebaseStatus.Error,
              message: 'Facebook AccessToken is null');
        }

        OAuthCredential credential;

        if (accessToken.type == AccessTokenType.limited) {
          credential = OAuthProvider("facebook.com").credential(
            idToken: accessToken.tokenString,
            rawNonce: rawNonce,
          );
        } else {
          credential = FacebookAuthProvider.credential(accessToken.tokenString);
        }

        userCredential = await _auth.signInWithCredential(credential);
        await FacebookAuth.instance.logOut();

        return FirebaseLoginStatus(
          status: FirebaseStatus.Success,
          message: userCredential,
        );
      } else if (facebookLoginResult.status == LoginStatus.cancelled) {
        return FirebaseLoginStatus(
            status: FirebaseStatus.Cancel, message: 'Facebook sign in cancel');
      } else {
        return FirebaseLoginStatus(
          status: FirebaseStatus.Error,
          message: facebookLoginResult.message ??
              'Facebook sign in failed or operation in progress',
        );
      }
    } catch (onError) {
      if (onError is FirebaseAuthException) {
        // Potentially log onError.code, onError.message if not already handled by a logger
      }
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError,
      );
    }
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
        accessToken: appleCredential.authorizationCode,
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
  Future<SignInMethodStatus> checkSignInMethod(String email) {
    return EmailSignInServices().checkSignInMethod(email);
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
