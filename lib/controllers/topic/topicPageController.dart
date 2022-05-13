import 'package:get/get.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/models/topicItem.dart';
import 'package:readr_app/services/topicService.dart';

class TopicPageController extends GetxController {
  final TopicRepos repository;
  final Topic topic;
  TopicPageController(this.repository, this.topic);

  final topicItemList = <TopicItem>[].obs;
  final String topicRecordApi =
      Environment().config.mirrorMediaDomain + '/api/v2/membership/v0/';
  bool isLoading = true;
  final isLoadingMore = false.obs;
  final isNoMore = false.obs;
  bool isError = false;
  bool isFeatured = false;

  @override
  void onInit() {
    super.onInit();
    fetchTopicItemList();
  }

  void fetchTopicItemList() async {
    isLoading = true;
    isError = false;
    update();
    try {
      List<TopicItem> items = [];
      switch (topic.type) {
        case TopicType.list:
          isFeatured = true;
          List<TopicItem> featuredList = await repository
              .fetchTopicItemList(_buildUrl(), isLoadingFirstPage: true);
          items.addAll(featuredList);
          if (featuredList.isEmpty || repository.isNoMore) {
            isFeatured = false;
            List<TopicItem> notFeaturedList = await repository
                .fetchTopicItemList(_buildUrl(), isLoadingFirstPage: true);
            items.addAll(notFeaturedList);
          }
          break;
        case TopicType.group:
          // TODO: Handle this case.
          break;
        case TopicType.portraitWall:
          // TODO: Handle this case.
          break;
      }

      topicItemList.assignAll(items);
      isNoMore.value = repository.isNoMore;
      isLoading = false;
    } catch (e) {
      print('Fetch topic story list error: $e');
      isError = true;
    }
    update();
  }

  void fetchMoreTopicItems() async {
    if (isFeatured && repository.isNoMore) {
      isFeatured = false;
      topicItemList.addAll(await repository.fetchTopicItemList(_buildUrl(),
          isLoadingFirstPage: true));
    } else {
      topicItemList.addAll(await repository.fetchNextPageTopicItemList());
    }
    isNoMore.value = repository.isNoMore;
  }

  String _buildUrl() {
    return topicRecordApi +
        'getposts?max_results=12&where={"isFeatured":$isFeatured,"topics":{"\$in":["${topic.id}"]}}&sort=-publishedDate&page=1';
  }
}
