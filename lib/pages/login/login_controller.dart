import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/providers/auth_info_provider.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/services/member_service.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool rxIsLoading = false.obs;
  final AuthInfoProvider authInfoProvider = Get.find();

  Future<void> anonymousLogin() async {
    rxIsLoading.value = true;
    UserCredential userCredential = await _auth.signInAnonymously();
    String? token = await userCredential.user?.getIdToken();
    final MemberService memberService = MemberService();

    if (token != null) {
      await memberService.createMember(
          _auth.currentUser!.email, _auth.currentUser!.uid, token);
      await authInfoProvider.fetchUserInfo();
      Fluttertoast.showToast(
          msg: '登入成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      rxIsLoading.value = false;
      RouteGenerator.navigateToLogin(isOff: true);
    } else {}

    rxIsLoading.value = false;
  }

  Future<void> loginOut() async {
    await _auth.signOut();
  }
}
