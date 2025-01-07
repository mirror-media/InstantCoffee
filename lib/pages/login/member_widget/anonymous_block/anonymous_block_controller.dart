import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/data/providers/auth_api_provider.dart';
import 'package:readr_app/data/providers/auth_info_provider.dart';
import 'package:readr_app/data/providers/graph_ql_provider.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/shared/premium_animate_page.dart';
import 'package:readr_app/widgets/toast_factory.dart';

class AnonymousBlockController extends GetxController {
  final AuthApiProvider authApiProvider = Get.find();
  final AuthInfoProvider authInfoProvider = Get.find();
  final GraphQLLinkProvider graphQLLinkProvider = Get.find();
  final RxBool rxIsLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();

    InAppPurchase.instance.purchaseStream.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    }, onError: (e) {});
    await authInfoProvider.fetchUserInfo();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    final subscriptionType =
        authInfoProvider.rxnUserAuthInfo.value?.subscriptionType;

    if (purchases.isEmpty) {
      String purchasesString = purchases[0].toString();
      if (purchasesString.isEmpty) {
        return;
      }
      return ;
    }

    final result = await authApiProvider.verifyPurchaseList(purchases);

    if (result == 'cancel') {
      ToastFactory.showToast('訂閱已被取消，請至App Store確認', ToastType.error);
      return;
    }

    if (result == 'none') {
      ToastFactory.showToast('查無訂閱資料', ToastType.error);
      return;
    }

    if (result == 'monthly' || result == 'yearly') {
      if (subscriptionType == SubscriptionType.subscribe_monthly ||
          subscriptionType == SubscriptionType.subscribe_yearly) {
        return;
      }
      await authInfoProvider.fetchUserInfo();

      authInfoProvider.rxnUserAuthInfo.value?.subscriptionType =
          SubscriptionType.subscribe_monthly;

      await RouteGenerator.navigatorKey.currentState!
          .pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AnimatePage(transitionAnimation: animation),
        transitionDuration: const Duration(milliseconds: 1500),
        reverseTransitionDuration: const Duration(milliseconds: 1000),
      ));

      ToastFactory.showToast('成功恢復訂閱資格', ToastType.success);
      if (authInfoProvider.rxnLoginType.value != LoginType.anonymous) {
        RouteGenerator.navigateToLogin(
            isOff: true,
            routeName: RouteGenerator.magazine,
            routeArguments: {
              'subscriptionType':
                  subscriptionType ?? SubscriptionType.subscribe_monthly,
            });
      }
    } else {
      ToastFactory.showToast('無法恢復訂閱資格', ToastType.error);
    }
    rxIsLoading.value = false;
  }

  void restorePurchasesButtonClick() async {
    rxIsLoading.value = true;
    await InAppPurchase.instance.restorePurchases();

    await Future.delayed(const Duration(seconds: 20));
    rxIsLoading.value = false;
  }

  void test() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user?.uid != null) {
      final result = await authApiProvider.getUserInfoFirebaseId(user!.uid);
    }
  }

  void signOutButtonClick() async {
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
    await RouteGenerator.navigatorKey.currentState!.push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AnimatePage(transitionAnimation: animation),
      transitionDuration: const Duration(milliseconds: 1500),
      reverseTransitionDuration: const Duration(milliseconds: 1000),
    ));
    Get.context!.read<MemberBloc>().add(UpdateSubscriptionType(
        isLogin: false, israfelId: null, subscriptionType: null));

    Get.back();
  }

  @override
  void onClose() {}
}
