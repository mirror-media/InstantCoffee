import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/providers/auth_api_provider.dart';
import 'package:readr_app/data/providers/auth_info_provider.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/widgets/toast_factory.dart';

class AnonymousBindController extends GetxController {
  TextEditingController eMailTextEditingController = TextEditingController();

  final AuthApiProvider authApiProvider = Get.find();
  final AuthInfoProvider authInfoProvider = Get.find();

  final RxBool rxIsHaveEmail = false.obs;
  final RxnString rxnEmailErrorMessage = RxnString();

  @override
  void onInit() {
    eMailTextEditingController.addListener(emailTextChangeEvent);
  }

  void googleBindButtonClickEvent() async {
    final user = await authInfoProvider.linkWithGoogle();
    displayBindResult(user);
  }

  void appleBindButtonClickEvent() async {
    final user = await authInfoProvider.linkWithApple();
    displayBindResult(user);
  }

  void facebookButtonClickEvent() async {
    final user = await authInfoProvider.linkWithFacebook();
    displayBindResult(user);
  }

  void displayBindResult(User? user) async {
    final token = await user?.getIdToken();
    final userId = authInfoProvider.rxnUserAuthInfo.value?.id;

    if (user == null || token == null || user.email == null || userId == null) {
      ToastFactory.showToast('綁定失敗', ToastType.error);
    } else {
      await authApiProvider.linkEmailFromAnonymous(
          email: user.email!, id: userId, token: token);

      await FirebaseAuth.instance.currentUser?.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser != null && updatedUser.email != null) {
        print('用户已更新：${updatedUser.email}');
        ToastFactory.showToast('成功綁定帳戶', ToastType.success);

        RouteGenerator.navigatorKey.currentState!.pop();
      } else {
        ToastFactory.showToast('帳戶更新失敗', ToastType.error);
      }
    }
  }

  void emailTextChangeEvent() {
    if (eMailTextEditingController.text.isEmpty) {
      rxIsHaveEmail.value = false;
      rxnEmailErrorMessage.value = null;
      return;
    }
    if (!eMailTextEditingController.text.isEmail) {
      rxnEmailErrorMessage.value = '請確認電子郵件格式';
      rxIsHaveEmail.value = false;
    } else {
      rxnEmailErrorMessage.value = null;
      rxIsHaveEmail.value = true;
    }
  }

  void nextButtonClickEvent() async {
    final email = eMailTextEditingController.text;
    await RouteGenerator.navigateToEmailRegistered(email: email);
  }
}
