import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
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
  static const String providerConflictMessage = 'login-provider-conflict';
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

    if (await _shouldBlockGoogleLogin(googleUser.email)) {
      return FirebaseLoginStatus(
        status: FirebaseStatus.Error,
        message: providerConflictMessage,
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

  Future<bool> _shouldBlockGoogleLogin(String? email) async {
    if (email == null || email.isEmpty) {
      return false;
    }
    try {
      final providers = await _fetchProvidersByIdentityToolkit(email);
      if (providers.isEmpty) {
        return false;
      }

      final hasFacebook = providers.contains('facebook.com');
      final hasGoogle = providers.contains('google.com');

      return hasFacebook && !hasGoogle;
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> _fetchProvidersByIdentityToolkit(String email) async {
    final apiKey = Firebase.app().options.apiKey;
    final uri = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:createAuthUri?key=$apiKey');

    final payload = jsonEncode({
      'identifier': email,
      'continueUri': 'https://firebaseappcheck.googleapis.com'
    });

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: payload,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
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
}
