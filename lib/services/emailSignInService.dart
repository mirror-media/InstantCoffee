import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';

class EmailSignInService {
  Future<bool> sendSignInLinkToEmail(FirebaseAuth auth, String email) async {
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
    var emailAuth = email;
    try{
      await auth.sendSignInLinkToEmail(
        email: emailAuth, 
        actionCodeSettings: acs
      );
    } catch(onError) {
      print('Error sending email verification $onError');
      return false;
    } 
    
    print('Successfully sent email verification');
    return true;
  }

  Future<FirebaseLoginStatus> verifyEmail(FirebaseAuth auth, String emailAuth, String emailLink) async {
    // Confirm the link is a sign-in with email link.
    if (auth.isSignInWithEmailLink(emailLink)) {
      // The client SDK will parse the code from the link for you.
      try {
        await auth.signInWithEmailLink(email: emailAuth?.trim(), emailLink: emailLink?.trim());
      } catch(onError) {
        print('Error verifing in with email link $onError');
        return FirebaseLoginStatus(
          status: FirebaseStatus.EmailVerifyError,
          message: onError.toString(),
        );
      }
      return FirebaseLoginStatus(
        status: FirebaseStatus.Success,
      );
    }
    return FirebaseLoginStatus(
      status: FirebaseStatus.Error,
      message: 'Email link error',
    );
  }
}