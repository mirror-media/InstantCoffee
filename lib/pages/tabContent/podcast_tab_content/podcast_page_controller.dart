import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/page_status.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/auth_provider.dart';
import 'package:readr_app/models/podcast_info/podcast_info.dart';

class PodcastPageController extends GetxController
    with GetTickerProviderStateMixin {
  final RxString rxTestString = 'test'.obs;
  final ArticlesApiProvider _articlesApiProvider = Get.find();
  final RxList<PodcastInfo> rxPodcastList = RxList();
  final RxList<PodcastInfo> rxRenderPodcastList = RxList();
  final Rx<PageStatus> rxPageStatus = PageStatus.loading.obs;
  final RxList<String> rxAuthorList = RxList();
  final RxnString rxCurrentAuthor = RxnString();
  final ScrollController scrollController = ScrollController();
  final AuthProvider authProvider = Get.find();
  final Rxn<PodcastInfo> rxnSelectPodcastInfo = Rxn();
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() async {
    super.onInit();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation =
        Tween(begin: -(authProvider.isLogin.isTrue ? 130.0 : 165.0), end: 0.0)
            .animate(animationController);
    rxPodcastList.value = await _articlesApiProvider.getPodcastInfo();
    for (final podcast in rxPodcastList) {
      if (!rxAuthorList.contains(podcast.author) && podcast.author != null) {
        rxAuthorList.add(podcast.author!);
      }
    }
    rxAuthorList.sort();
    setCurrentAuthor(rxAuthorList[0], isInit: true);

    rxPageStatus.value = PageStatus.normal;
  }

  void setCurrentAuthor(String? author, {bool isInit = false}) {
    if (author == null) {
      return;
    }
    rxCurrentAuthor.value = author;
    rxRenderPodcastList.clear();
    if (!isInit) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
    rxRenderPodcastList
        .addAll(rxPodcastList.where((p0) => p0.author == author));
  }

  void podcastInfoSelectEvent(PodcastInfo podcastInfo) {
    if (rxnSelectPodcastInfo.value == podcastInfo) {
      rxnSelectPodcastInfo.value = null;
      animationController.reverse();
      return;
    }

    if (rxnSelectPodcastInfo.value == null) {
      animationController.forward();
    }

    rxnSelectPodcastInfo.value = podcastInfo;
  }

  void testButtonClick() {
    animationController.forward();
  }
}
