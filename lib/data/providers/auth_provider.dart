import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/providers/auth_api_provider.dart';
import 'package:readr_app/models/member_info.dart';

class AuthProvider extends GetxController {
  AuthProvider._();

  static final AuthProvider _instance = AuthProvider._();

  static AuthProvider get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthApiProvider authApiProvider = Get.find();
  final RxBool isLogin = false.obs;
  late String? idToken;
  final RxnString accessToken = RxnString();
  final Rxn<MemberInfo> rxnMemberInfo = Rxn();

  User? userIndex;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen(authStateChangesEvent);
    Timer.periodic(const Duration(minutes: 55), updateJWTToken);
  }

  void updateJWTToken(Timer timer) {
    if (userIndex != null) {
      updateUserInfo(userIndex!);
    }
  }

  void authStateChangesEvent(User? user) {
    if (user != null) {
      isLogin.value = true;
      updateUserInfo(user);
      userIndex = user;
    } else {
      isLogin.value = false;
      idToken = null;
      accessToken.value = null;
      rxnMemberInfo.value = null;
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
  }

  void updateUserInfo(User user) async {
    idToken = await user.getIdToken();
    if (idToken != null) {
      accessToken.value =
          await authApiProvider.getAccessTokenByIdToken(idToken!);
      rxnMemberInfo.value = await authApiProvider.checkSubscriptionType(user);

    }
  }
}
