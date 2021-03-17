import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInService{
  // https://stackoverflow.com/questions/62805312/android-sign-in-with-apple-and-firebase-flutter
  // need a backend server to support apple sign in on android
  // but we don't support apple sign in on android in this app
  Future<FirebaseLoginStatus> signInWithApple(FirebaseAuth auth) async {
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
      await auth.signInWithCredential(oauthCredential);
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