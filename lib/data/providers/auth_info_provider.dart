import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/providers/auth_api_provider.dart';

class AuthInfoProvider extends GetxController {
  AuthInfoProvider._();

  static final AuthInfoProvider _instance = AuthInfoProvider._();

  static AuthInfoProvider get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthApiProvider authApiProvider = Get.find();
  final RxBool isLogin =false.obs;
  late String? idToken;
  final RxnString accessToken = RxnString();
  User? userIndex;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen(authStateChangesEvent);
    Timer.periodic(const Duration(minutes: 55), updateJWTTokenEvent);
  }

  void updateJWTTokenEvent(Timer timer) {
    if (userIndex != null) {
      updateUserInfo(userIndex!);
    }
  }

  void updateJWTToken()async{
    if(userIndex==null) {
      return;
    }
    idToken = await userIndex?.getIdToken();
    if (idToken != null) {
      accessToken.value =
          await authApiProvider.getAccessTokenByIdToken(idToken!);
    }

  }


  void authStateChangesEvent(User? user) {
    if (user != null) {
      isLogin.value=true;
      updateUserInfo(user);
      userIndex = user;
    } else {
      isLogin.value=false;
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
  }

  void updateUserInfo(User user) async {
    idToken = await user.getIdToken();
    if (idToken != null) {
      accessToken.value =
          await authApiProvider.getAccessTokenByIdToken(idToken!);
    }
  }
}
