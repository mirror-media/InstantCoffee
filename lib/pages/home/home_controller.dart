import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/live_stream_model.dart';
import 'package:readr_app/services/app_cache_service.dart';
import 'package:readr_app/helpers/notice_dialog_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../blocs/onBoarding/bloc.dart';
import '../../helpers/app_link_helper.dart';
import '../../helpers/firebase_messaging_helper.dart';
import '../../models/topic/topic_model.dart';
import '../termsOfService/m_m_terms_of_service_page.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  ArticlesApiProvider articlesApiProvider = Get.find();
  late BuildContext? context;
  late OnBoardingBloc onBoardingBloc;
  late PageController pageController;
  final RxInt rxSelectedIndex = 0.obs;
  final RxList<TopicModel> rxTopicList = RxList();
  final ScrollController premiumArticleBarScrollController = ScrollController();
  final Rxn<LiveStreamModel> rxLiveStreamModel = Rxn();
  final LocalStorage _storage = LocalStorage('setting');
  final AppLinkHelper _appLinkHelper = AppLinkHelper();
  final AppCacheService appCacheService = Get.find();

  final FirebaseMessangingHelper _firebaseMessageHelper =
      FirebaseMessangingHelper();
  YoutubePlayerController ytStreamController =
      YoutubePlayerController(initialVideoId: '');

  void setContext(BuildContext context) {
    this.context = context;
    initState();
    configLiveStream();
  }

  @override
  void onInit() {
    super.onInit();
    _showTermsOfService();
  }

  Future<void> initState() async {
    if (context == null) return;
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // _appLinkHelper.configAppLink(context!);
      _appLinkHelper.listenAppLink(context!);
      _firebaseMessageHelper.configFirebaseMessaging();
    });

    onBoardingBloc = context!.read<OnBoardingBloc>();
    pageController = PageController(initialPage: rxSelectedIndex.value);
    rxTopicList.value = await articlesApiProvider.getTopicTabList() ?? [];

    NoticeDialogHelper.showIfNeeded(context!);
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
    // _appLinkHelper.dispose();
    _firebaseMessageHelper.dispose();
    super.dispose();
  }
}
