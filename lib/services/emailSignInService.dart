import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';

abstract class EmailSignInRepos {
  Future<List<String>> fetchSignInMethodsForEmail(String email);
  Future<FirebaseLoginStatus> createUserWithEmailAndPassword(String email, String password);
  Future<FirebaseLoginStatus> signInWithEmailAndPassword(String email, String password);
  Future<FirebaseLoginStatus> sendPasswordResetEmail(String email);
  Future<FirebaseLoginStatus> sendEmailVerification(String email, String redirectUrl);
  Future<FirebaseLoginStatus> applyActionCode(String code);
  Future<bool> confirmPasswordReset(String code, String newPassword);
  Future<bool> confirmOldPassword(String oldPassword);
  Future<bool> updatePassword(String newPassword);
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
    UserCredential userCredential;
    try {
      // Once signed in, get the UserCredential
      userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch(onError) {
      print('Error create user with email and password: $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.code,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: userCredential,
    );
  }

  Future<FirebaseLoginStatus> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential;
    try {
      // Once signed in, get the UserCredential
      userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch(onError) {
      print('Error sign in with email and password: $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.code,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: userCredential,
    );
  }

  Future<FirebaseLoginStatus> sendPasswordResetEmail(String email) async {
    var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: Environment().config.recoverPasswordUrl,
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: Environment().config.iOSBundleId,
      androidPackageName: Environment().config.androidPackageName,
      // installIfNotAvailable
      androidInstallApp: false,
      // minimumVersion
      androidMinimumVersion: "12",
      dynamicLinkDomain: Environment().config.dynamicLinkDomain,
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
  
  /// If input email and auth current user email is different,
  /// it will verify the input email before updating email.
  /// Or it will only send auth current user email verification.
  Future<FirebaseLoginStatus> sendEmailVerification(String email, String redirectUrl) async {
    var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: redirectUrl,
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: Environment().config.iOSBundleId,
      androidPackageName: Environment().config.androidPackageName,
      // installIfNotAvailable
      androidInstallApp: false,
      // minimumVersion
      androidMinimumVersion: "12",
      dynamicLinkDomain: Environment().config.dynamicLinkDomain,
    );

    try{
      if(_auth.currentUser.email == null || _auth.currentUser.email != email) {
        _auth.currentUser.verifyBeforeUpdateEmail(email, acs);
      }
      
      await _auth.currentUser.sendEmailVerification(acs);
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

  @override
  Future<FirebaseLoginStatus> applyActionCode(String code) async{
    try {
      await _auth.applyActionCode(code);
      if(_auth.currentUser != null) {
        _auth.currentUser.reload();
      }
    } catch(onError) {
      print('Apply actionCode success error $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError.code,
      );
    }
    
    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Apply actionCode success',
    );
  }

  Future<bool> confirmPasswordReset(String code, String newPassword) async {
    try{
      await _auth.confirmPasswordReset(
        code: code, 
        newPassword: newPassword
      );
    } catch(onError) {
      print('Error confirm password reset $onError');
      return false;
    } 
    
    print('Confirm password reset successfully');
    return true;
  }

  Future<bool> confirmOldPassword(String oldPassword) async {
    var user = _auth.currentUser;
    var credential = EmailAuthProvider.credential(
      email: user.email,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
    } catch(onError) {
      print('Confirm old password with firebase $onError');
      return false;
    }

    return true;
  }

  Future<bool> updatePassword(String newPassword) async {
    try{
      await _auth.currentUser.updatePassword(newPassword);
    } catch(onError) {
      print('Error update password $onError');
      return false;
    } 
  
    print('Update password successfully');
    return true;
  }
}