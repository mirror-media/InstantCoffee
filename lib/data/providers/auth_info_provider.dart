import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/data/providers/auth_api_provider.dart';
import 'package:readr_app/models/user_auth_info.dart';
import 'package:readr_app/widgets/toast_factory.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthInfoProvider extends GetxController {
  AuthInfoProvider._();

  static final AuthInfoProvider _instance = AuthInfoProvider._();

  static AuthInfoProvider get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthApiProvider authApiProvider = Get.find();
  final RxBool rxIsLogin = false.obs;
  final Rxn<LoginType> rxnLoginType = Rxn();
  late String? idToken;
  final RxnString accessToken = RxnString();
  final Rxn<UserAuthInfo> rxnUserAuthInfo = Rxn();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? userIndex;

  @override
  void onInit() async {
    super.onInit();
    _auth.authStateChanges().listen(authStateChangesEvent);
    Timer.periodic(const Duration(minutes: 55), updateJWTTokenEvent);
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        authLogout();
      } else {
        _getSignInProvider(user);
      }
    });
    userIndex = _auth.currentUser;
    await fetchUserInfo();
  }

  void _getSignInProvider(User user) {
    if (user.isAnonymous) {
      rxnLoginType.value = LoginType.anonymous;
      return;
    }

    for (var userInfo in user.providerData) {
      switch (userInfo.providerId) {
        case 'google.com':
          rxnLoginType.value = LoginType.google;
          break;
        case 'apple.com':
          rxnLoginType.value = LoginType.apple;
          break;
        case 'facebook.com':
          rxnLoginType.value = LoginType.facebook;
          break;
        case 'password':
          rxnLoginType.value = LoginType.email;
          break;
        case 'anonymous':
          rxnLoginType.value = LoginType.anonymous;
          break;
        default:
          print('Unknown provider: ${userInfo.providerId}');
          break;
      }
    }
  }

  void updateJWTTokenEvent(Timer timer) {
    if (userIndex != null) {
      updateUserInfo(userIndex!);
    }
  }

  void updateJWTToken() async {
    if (userIndex == null) {
      return;
    }
    idToken = await userIndex?.getIdToken();
    if (idToken != null) {
      Future.delayed(const Duration(seconds: 30), () async {
        if (idToken != null) {
          accessToken.value =
              await authApiProvider.getAccessTokenByIdToken(idToken!);
        }
      });
    }
  }

  void authStateChangesEvent(User? user) async {
    if (user != null) {
      rxIsLogin.value = true;
      updateUserInfo(user);
      userIndex = user;
    } else {
      rxIsLogin.value = false;
      idToken = null;
      accessToken.value = null;
    }
  }

  void authLogin() {
    if (userIndex != null) {
      updateUserInfo(userIndex!);
    } else {
      idToken = null;
      accessToken.value = null;
    }
  }

  void authLogout() {
    idToken = null;
    accessToken.value = null;
    rxnUserAuthInfo.value = null;
  }

  void updateUserInfo(User user) async {
    await fetchUserInfo();
    idToken = await user.getIdToken();
    if (idToken != null) {
      accessToken.value =
          await authApiProvider.getAccessTokenByIdToken(idToken!);
    }
  }

  Future<void> fetchUserInfo() async {
    updateJWTToken();
    if (userIndex?.uid != null) {
      rxnUserAuthInfo.value =
          await authApiProvider.getUserInfoFirebaseId(userIndex!.uid);
    }
  }

  Future<void> changeSubscriptionTypeToMonthly() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final result = await authApiProvider.getUserInfoFirebaseId(user.uid);
      print(result);
    }
  }

  Future<User?> linkWithGoogle() async {
    try {
      User? user = _auth.currentUser;
      if (user == null || !user.isAnonymous) {
        ToastFactory.showToast('未找到匿名帳號或用戶未登入。', ToastType.error);
        return null;
      }
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("用戶取消了 Google 登錄。");
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await user.linkWithCredential(credential);

      rxnLoginType.value = LoginType.google;
      return userCredential.user;
    } catch (e) {
      ToastFactory.showToast('合併匿名帳號與 Google 帳號失敗：$e', ToastType.error);
      return null;
    }
  }

  Future<User?> linkWithApple() async {
    try {
      User? user = _auth.currentUser;
      if (user == null || !user.isAnonymous) {
        ToastFactory.showToast('未找到匿名帳號或用戶未登入。', ToastType.error);
        return null;
      }

      // Apple 授權登錄，獲取 Apple 憑證
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 創建 OAuth 憑證
      final AuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // 合併帳號
      final UserCredential userCredential =
          await user.linkWithCredential(credential);

      // 更新狀態
      rxnLoginType.value = LoginType.apple;

      ToastFactory.showToast('成功合併匿名帳號與 Apple 帳號', ToastType.success);
      return userCredential.user;
    } catch (e) {
      ToastFactory.showToast('合併匿名帳號與 Apple 帳號失敗：$e', ToastType.error);
      return null;
    }
  }

  Future<User?> linkWithFacebook() async {
    try {
      User? user = _auth.currentUser;
      if (user == null || !user.isAnonymous) {
        ToastFactory.showToast('未找到匿名帳號或用戶未登入。', ToastType.error);
        return null;
      }

      // Facebook 登入
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success) {
        print("Facebook 登錄失敗或用戶取消了登錄：${loginResult.message}");
        return null;
      }

      final AccessToken? accessToken = loginResult.accessToken;
      if (accessToken == null) {
        print("Facebook Access Token 不存在。");
        return null;
      }

      final AuthCredential credential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      // 合併帳號
      final UserCredential userCredential =
          await user.linkWithCredential(credential);
      rxnLoginType.value = LoginType.facebook;
      return userCredential.user;
    } catch (e) {
      ToastFactory.showToast('合併匿名帳號與 Facebook 帳號失敗：$e', ToastType.error);
      return null;
    }
  }
}
