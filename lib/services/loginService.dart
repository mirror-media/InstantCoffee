
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';

abstract class LoginRepos {
  Future<FirebaseLoginStatus> signInWithGoogle();
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
}