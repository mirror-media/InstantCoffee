import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

import '../../blocs/onBoarding/bloc.dart';
import '../../helpers/app_link_helper.dart';
import '../../helpers/firebase_messaging_helper.dart';
import '../termsOfService/m_m_terms_of_service_page.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  late BuildContext? context;
  late OnBoardingBloc onBoardingBloc;
  late PageController pageController;
  final RxInt rxSelectedIndex = 0.obs;
  final ScrollController premiumArticleBarScrollController = ScrollController();

  final LocalStorage _storage = LocalStorage('setting');
  final AppLinkHelper _appLinkHelper = AppLinkHelper();
  final FirebaseMessangingHelper _firebaseMessageHelper =
      FirebaseMessangingHelper();

  void setContext(BuildContext context) {
    this.context = context;
    initState();
  }

  void initState() {
    if (context == null) return;
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _appLinkHelper.configAppLink(context!);
      _appLinkHelper.listenAppLink(context!);
      _firebaseMessageHelper.configFirebaseMessaging();
    });

    onBoardingBloc = context!.read<OnBoardingBloc>();
    pageController = PageController(initialPage: rxSelectedIndex.value);
    _showTermsOfService();
  }

  _showTermsOfService() async {
    if (await _storage.ready && context != null) {
      bool? isAcceptTerms = await _storage.getItem("isAcceptTerms");
      if (isAcceptTerms == null || !isAcceptTerms) {
        _storage.setItem("isAcceptTerms", false);
        await Future.delayed(const Duration(seconds: 1));
        await Navigator.of(context!).push(PageRouteBuilder(
            barrierDismissible: false,
            pageBuilder: (BuildContext context, _, __) =>
                MMTermsOfServicePage()));
      }
    }
  }

  void onItemTapped(int index) {
    if (rxSelectedIndex.value == index && rxSelectedIndex.value == 2) {
      premiumArticleBarScrollController.animateTo(
          premiumArticleBarScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    }

    if (rxSelectedIndex.value != index) {
      rxSelectedIndex.value = index;
    }
    pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _appLinkHelper.dispose();
    _firebaseMessageHelper.dispose();
    super.dispose();
  }
}
