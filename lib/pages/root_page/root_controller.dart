import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/data/enum/navigation_page.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/auth_provider.dart';
import 'package:readr_app/models/live_stream_model.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../helpers/app_link_helper.dart';
import '../../helpers/firebase_messaging_helper.dart';
import '../../models/topic/topic_model.dart';

class RootController extends GetxController
    with WidgetsBindingObserver, GetSingleTickerProviderStateMixin {
  ArticlesApiProvider articlesApiProvider = Get.find();

  final AuthProvider authProvider = Get.find();
  final RxList<TopicModel> rxTopicList = RxList();
  final ScrollController premiumArticleBarScrollController = ScrollController();
  final Rxn<LiveStreamModel> rxLiveStreamModel = Rxn();
  final LocalStorage _storage = LocalStorage('setting');
  final AppLinkHelper _appLinkHelper = AppLinkHelper();
  final FirebaseMessangingHelper _firebaseMessageHelper =
      FirebaseMessangingHelper();
  YoutubePlayerController ytStreamController =
      YoutubePlayerController(initialVideoId: '');
  final Rx<NavigationPage> rxCurrentNavigationPage =
      Rx<NavigationPage>(NavigationPage.home);

  @override
  void onInit() async {
    super.onInit();
    initState();
    configLiveStream();
  }

  Future<void> initState() async {
    WidgetsBinding.instance.addObserver(this);

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _appLinkHelper.configAppLink(context!);
    //   _appLinkHelper.listenAppLink(context!);
    //   _firebaseMessageHelper.configFirebaseMessaging();
    // });

    rxTopicList.value = await articlesApiProvider.getTopicTabList() ?? [];
  }

  ///不知道這是幹什麼的 先註解掉 有需要再調整回來
  _showTermsOfService() async {
    // if (await _storage.ready && context != null) {
    //   bool? isAcceptTerms = await _storage.getItem("isAcceptTerms");
    //   if (isAcceptTerms == null || !isAcceptTerms) {
    //     _storage.setItem("isAcceptTerms", false);
    //     await Future.delayed(const Duration(seconds: 1));
    //     await Navigator.of(context!).push(PageRouteBuilder(
    //         barrierDismissible: false,
    //         pageBuilder: (BuildContext context, _, __) =>
    //             MMTermsOfServicePage()));
    //   }
    // }
  }

  void onItemTapped(int index) {
    rxCurrentNavigationPage.value = NavigationPage.values[index];
    if (rxCurrentNavigationPage.value == NavigationPage.premium) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().gotoPremium();
      } else {
        Get.offAndToNamed(NavigationPage.home.router,
            id: 1, arguments: {'tab': 'premium'});
      }
    } else if (rxCurrentNavigationPage.value == NavigationPage.bookmark) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().gotoBookmark();
      } else {
        Get.offAndToNamed(NavigationPage.home.router,
            id: 1, arguments: {'tab': 'bookmark'});
      }
    } else {
      Get.offAndToNamed(rxCurrentNavigationPage.value.router, id: 1);
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().gotoBookmark();
      }
    }
  }

  void configLiveStream() async {
    rxLiveStreamModel.value = await articlesApiProvider.getLiveStreamModel();
    final link = rxLiveStreamModel.value?.link;
    if (link == null) return;
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(link);
    if (videoId == null) return;
    ytStreamController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(isLive: false, autoPlay: false));
  }

  @override
  void dispose() {
    _appLinkHelper.dispose();
    _firebaseMessageHelper.dispose();
    super.dispose();
  }
}
