import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/models/sign_in_method_status.dart';
import 'package:readr_app/widgets/logger.dart';

abstract class EmailSignInRepos {
  Future<SignInMethodStatus> checkSignInMethod(String email);
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
  Future<SignInMethodStatus> checkSignInMethod(String email) async {
    if (_auth.currentUser != null) {
      final currentUser = _auth.currentUser!;
      final currentEmail = currentUser.email;
      if (currentEmail != null &&
          currentEmail.toLowerCase() == email.toLowerCase()) {
        final providerIds =
            currentUser.providerData.map((provider) => provider.providerId);
        if (providerIds.contains('password')) {
          return SignInMethodStatus.password;
        }
        if (providerIds.isNotEmpty) {
          return SignInMethodStatus.thirdParty;
        }
      }

      debugLog(
          'Skip checkSignInMethod for $email because a user is already signed in');
      return SignInMethodStatus.unknown;
    }

    try {
      final providers = await _fetchProvidersByIdentityToolkit(email);
      if (providers.isEmpty) {
        return SignInMethodStatus.notRegistered;
      }

      final hasPassword = providers.contains('password');
      final hasThirdParty = providers.any((provider) => provider != 'password');

      if (hasPassword && !hasThirdParty) {
        return SignInMethodStatus.password;
      }
      if (hasThirdParty) {
        return SignInMethodStatus.thirdParty;
      }

      return SignInMethodStatus.password;
    } on TimeoutException catch (error) {
      debugLog('Check sign in method timeout for $email: $error');
      return SignInMethodStatus.unknown;
    } catch (error) {
      debugLog('Unexpected error when checking sign in method: $error');
      return SignInMethodStatus.unknown;
    }
  }

  Future<List<String>> _fetchProvidersByIdentityToolkit(String email) async {
    final apiKey = Firebase.app().options.apiKey;
    final uri = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:createAuthUri?key=$apiKey');

    final payload = jsonEncode({
      'identifier': email,
      'continueUri': Environment().config.mirrorMediaDomain,
    });

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: payload,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      debugLog(
          'IdentityToolkit lookup failed: ${response.statusCode} ${response.body}');
      return [];
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return [];
    }

    final providers = decoded['allProviders'];
    if (providers is List) {
      return providers.whereType<String>().toList();
    }

    final registered = decoded['registered'];
    if (registered is bool && !registered) {
      return [];
    }

    return [];
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
