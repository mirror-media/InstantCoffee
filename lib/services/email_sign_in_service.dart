import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/widgets/logger.dart';

abstract class EmailSignInRepos {
  Future<List<String>> fetchSignInMethodsForEmail(String email);
  Future<FirebaseLoginStatus> createUserWithEmailAndPassword(
      String email, String password);
  Future<FirebaseLoginStatus> signInWithEmailAndPassword(
      String email, String password);
  Future<FirebaseLoginStatus> sendPasswordResetEmail(String email);
  Future<FirebaseLoginStatus> sendEmailVerification(
      String email, String redirectUrl);
  Future<FirebaseLoginStatus> applyActionCode(String code);
  Future<bool> confirmPasswordReset(String code, String newPassword);
  Future<bool> confirmOldPassword(String oldPassword);
  Future<bool> updatePassword(String newPassword);
}

class EmailSignInServices with Logger implements EmailSignInRepos {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  Future<FirebaseLoginStatus> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential;
    try {
      // Once signed in, get the UserCredential
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (onError) {
      debugLog('Error create user with email and password: $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError is FirebaseAuthException ? onError.code : onError,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: userCredential,
    );
  }

  @override
  Future<FirebaseLoginStatus> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential;
    try {
      // Once signed in, get the UserCredential
      userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (onError) {
      debugLog('Error sign in with email and password: $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError is FirebaseAuthException ? onError.code : onError,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: userCredential,
    );
  }

  @override
  Future<FirebaseLoginStatus> sendPasswordResetEmail(String email) async {
    var acs = ActionCodeSettings(
      url: Environment().config.recoverPasswordUrl,
      handleCodeInApp: false,
    );

    try {
      await _auth.sendPasswordResetEmail(email: email, actionCodeSettings: acs);
    } catch (onError) {
      debugLog('Error sending password reset email $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError is FirebaseAuthException ? onError.code : onError,
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
  @override
  Future<FirebaseLoginStatus> sendEmailVerification(
      String email, String redirectUrl) async {
    var acs = ActionCodeSettings(
      url: Environment().config.finishEmailVerificationUrl,
      handleCodeInApp: false,
    );

    try {
      if (_auth.currentUser!.email == null ||
          _auth.currentUser!.email != email) {
        _auth.currentUser!.verifyBeforeUpdateEmail(email, acs);
      }

      await _auth.currentUser!.sendEmailVerification(acs);
    } catch (onError) {
      debugLog('Error sending password reset email $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError is FirebaseAuthException ? onError.code : onError,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Send password reset email: with firebase success',
    );
  }

  @override
  Future<FirebaseLoginStatus> applyActionCode(String code) async {
    try {
      await _auth.applyActionCode(code);
      _auth.currentUser!.reload();
    } catch (onError) {
      debugLog('Apply actionCode success error $onError');
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: onError is FirebaseAuthException ? onError.code : onError,
      );
    }

    return FirebaseLoginStatus(
      status: FirebaseStatus.Success,
      message: 'Apply actionCode success',
    );
  }

  @override
  Future<bool> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } catch (onError) {
      debugLog('Error confirm password reset $onError');
      return false;
    }

    debugLog('Confirm password reset successfully');
    return true;
  }

  @override
  Future<bool> confirmOldPassword(String oldPassword) async {
    User user = _auth.currentUser!;
    var credential = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
    } catch (onError) {
      debugLog('Confirm old password with firebase $onError');
      return false;
    }

    return true;
  }

  @override
  Future<bool> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (onError) {
      debugLog('Error update password $onError');
      return false;
    }

    debugLog('Update password successfully');
    return true;
  }
}
