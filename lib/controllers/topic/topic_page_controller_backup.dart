import 'package:get/get.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/models/topic_image_item.dart';
import 'package:readr_app/models/topic_item.dart';
import 'package:readr_app/services/topic_service.dart';
import 'package:readr_app/widgets/logger.dart';

import '../../data/enum/topic_type.dart';

class TopicPageControllerBackup extends GetxController with Logger {
  late TopicRepos repository;
  late final Topic topic;
  TopicPageControllerBackup();

  final topicItemList = <TopicItem>[].obs;
  final List<TopicImageItem> portraitWallItemList = [];
  bool isLoading = true;
  final isLoadingMore = false.obs;
  final isNoMore = false.obs;
  bool isError = false;
  bool isFeatured = false;

  @override
  void onInit() {
    super.onInit();
    fetchTopicItemList();
    final argument = Get.arguments as Map<String, dynamic>;

    repository = TopicService();
    topic = argument['topic'];
    fetchTopicItemList();

  }


  void fetchTopicItemList() async {
    isLoading = true;
    isError = false;
    update();
    try {
      switch (topic.type) {
        case TopicType.slideshow:
        case TopicType.list:
          List<TopicItem> items = [];
          isFeatured = true;
          List<TopicItem> featuredList = await repository
              .fetchTopicItemList(_buildRecordUrl(), isLoadingFirstPage: true);
          items.addAll(featuredList);
          if (featuredList.isEmpty || repository.isNoMore) {
            isFeatured = false;
            List<TopicItem> notFeaturedList =
                await repository.fetchTopicItemList(_buildRecordUrl(),
                    isLoadingFirstPage: true);
            items.addAll(notFeaturedList);
          }
          topicItemList.assignAll(items);
          break;
        case TopicType.group:
          List<TopicItem> groupTopicList = await repository.fetchTopicItemList(
            _buildRecordUrl(),
            isLoadingFirstPage: true,
            tagIdList: topic.tagIdList,
          );
          isNoMore.value = repository.isNoMore;
          while (!isNoMore.value) {
            groupTopicList.addAll(await repository.fetchNextPageTopicItemList(
              tagIdList: topic.tagIdList,
            ));
            isNoMore.value = repository.isNoMore;
          }
          topicItemList.assignAll(_sortByMap(groupTopicList));
          break;
        case TopicType.portraitWall:
          portraitWallItemList.assignAll(await repository.fetchPortraitWallList(
              _buildImageUrl(), _buildRecordUrl()));
          break;
      }

      isNoMore.value = repository.isNoMore;
      isLoading = false;
    } catch (e) {
      debugLog('Fetch topic story list error: $e');
      isError = true;
    }
    update();
  }

  void fetchMoreTopicItems() async {
    if (isFeatured && repository.isNoMore) {
      isFeatured = false;
      topicItemList.addAll(await repository
          .fetchTopicItemList(_buildRecordUrl(), isLoadingFirstPage: true));
    } else {
      topicItemList.addAll(await repository.fetchNextPageTopicItemList(
        tagIdList: topic.tagIdList,
      ));
    }
    isNoMore.value = repository.isNoMore;
  }

  String _buildRecordUrl() {
    return '${Environment().config.mirrorMediaDomain}/api/v2/membership/v0/getposts?max_results=12&where={"isFeatured":$isFeatured,"topics":{"\$in":["${topic.id}"]}}&sort=-publishedDate&page=1';
  }

  String _buildImageUrl() {
    return '${Environment().config.mirrorMediaDomain}/api/v2/images?where={"topics":{"\$in":["${topic.id}"]}}&max_results=25';
  }

  List<TopicItem> _sortByMap(List<TopicItem> items) {
    items.removeWhere((element) => element.tagId == null);
    if (topic.tagOrderMap != null && topic.tagOrderMap!.isNotEmpty) {
      items.sort((a, b) {
        if (topic.tagOrderMap!.containsKey(a.tagId) &&
            topic.tagOrderMap!.containsKey(b.tagId)) {
          int orderCompare = topic.tagOrderMap![a.tagId]!
              .compareTo(topic.tagOrderMap![b.tagId]!);
          if (orderCompare != 0) {
            return orderCompare;
          } else {
            return b.record.publishedDate.compareTo(a.record.publishedDate);
          }
        }

        return b.record.publishedDate.compareTo(a.record.publishedDate);
      });
    } else {
      Map<String, int> tagOrderMap = {};
      int order = 0;
      for (var item in items) {
        tagOrderMap.putIfAbsent(item.tagId!, () => order);
        order++;
      }
      items.sort((a, b) {
        int orderCompare =
            tagOrderMap[a.tagId]!.compareTo(tagOrderMap[b.tagId]!);
        if (orderCompare != 0) {
          return orderCompare;
        }

        return b.record.publishedDate.compareTo(a.record.publishedDate);
      });
    }
    return items;
  }
}
