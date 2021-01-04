import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';

class FacebookSignInService {
  final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<FirebaseLoginStatus> signInWithFacebook(FirebaseAuth auth) async {
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
           await auth.signInWithCredential(credential);
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
}