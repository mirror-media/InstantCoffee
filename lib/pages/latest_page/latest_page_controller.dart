import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/live_stream_model.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section_ad.dart';
import 'package:readr_app/routes/routes.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LatestPageController extends GetxController {
  final Rxn<SectionAd> rxnSectionAd = Rxn();
  final RxList<Record> rxEditorChoiceList = RxList();
  final ArticlesApiProvider articlesApiProvider = Get.find();
  final Rxn<LiveStreamModel> rxLiveStreamModel = Rxn();
  final RxList<Record> rxRenderRecordList = RxList();
  final RxList<Record> rxStoreRecordList = RxList();
  final ScrollController scrollController = ScrollController();

  int page = 1;
  int recordIndex = 0;
  YoutubePlayerController ytStreamController =
  YoutubePlayerController(initialVideoId: '');

  @override
  void onInit() async {
    rxEditorChoiceList.value = await articlesApiProvider.getChoicesRecordList();
    configLiveStream();
    addRecordToRender();
    scrollController.addListener(scrollEvent);
    AdHelper adHelper = AdHelper();
    rxnSectionAd.value = await adHelper.getSectionAdBySlug('latest');
  }

  void scrollEvent() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page++;
      addRecordToRender();
    }
  }

  void addRecordToRender() async {
    if (rxStoreRecordList.length <= rxRenderRecordList.length) {
      await fetchMoreRecord();
    }
    int addCount = recordIndex + 10 > rxStoreRecordList.length - 1
        ? rxStoreRecordList.length - 1
        : recordIndex + 10;
    rxRenderRecordList
        .addAll(rxStoreRecordList.getRange(recordIndex, addCount));
    recordIndex += 10;
  }

  Future<void> fetchMoreRecord() async {
    if (page > 4) return;
    final newRecordList =
    await articlesApiProvider.getHomePageLatestArticleList(page: page);
    rxStoreRecordList.addAll(newRecordList);
    page++;
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

  void navigateToStoryPage(Record record) {
    if (record.slug == null) {
      return;
    }
    Get.toNamed(
        Routes.articlePage, arguments: {'record': record}, id: Routes.
        navigationKey);
    return;

    if (record.isExternal) {
      RouteGenerator.navigateToExternalStory(record.slug!, isPremiumMode: true);
    } else {
      RouteGenerator.navigateToStory(
        record.slug!,
        isMemberCheck: record.isMemberCheck,
        url: record.url,
      );
    }
  }
}
