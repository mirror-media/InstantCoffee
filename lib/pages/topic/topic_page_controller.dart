import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/topic_page_status.dart';

import '../../data/providers/articles_api_provider.dart';
import '../../helpers/environment.dart';
import '../../models/post/post_model.dart';
import '../../models/story_ad.dart';
import '../../models/topic/topic_model.dart';
import '../../models/topic_image_item.dart';
import '../../models/topic_item.dart';
import '../../services/topic_service.dart';

class TopicPageController extends GetxController {
  late TopicRepos repository;
  final ArticlesApiProvider articlesApiProvider = Get.find();

  final Rxn<TopicModel> rxCurrentTopic = Rxn();
  final RxList<PostModel> rxRelatedPostList = RxList();
  final Rxn<StoryAd> rxStoryAd = Rxn();
  final Rx<TopicPageStatus> rxPageStatus =
      Rx<TopicPageStatus>(TopicPageStatus.normal);
  final RxBool rxIsEnd = false.obs;

  ScrollController scrollController = ScrollController(keepScrollOffset:true);

  int listCountIndex = 1;

  final topicItemList = <TopicItem>[].obs;
  final List<TopicImageItem> portraitWallItemList = [];
  bool isFeatured = false;

  @override
  void onInit() {
    super.onInit();
    final argument = Get.arguments as Map<String, dynamic>;
    if (argument.containsKey('topic')) {
      rxCurrentTopic.value = argument['topic'];
    }
    repository = TopicService();
    fetchTopicItemList();
    _loadAds();
    scrollController.addListener(scrollEvent);
  }

  void scrollEvent() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      rxPageStatus.value = TopicPageStatus.loading;
      loadMoreArticleEvent();
      rxPageStatus.value = TopicPageStatus.normal;
    }
  }

  void fetchTopicItemList() async {
    rxPageStatus.value = TopicPageStatus.loading;
    try {
      final topicId = rxCurrentTopic.value?.id;
      if (topicId == null) return;
      rxRelatedPostList.value = await articlesApiProvider
          .getRelatedPostsByTopic(topicId: topicId);
      rxPageStatus.value = TopicPageStatus.normal;
    } catch (e) {
      debugLog('Fetch topic story list error: $e');
      rxPageStatus.value = TopicPageStatus.error;
    }
  }

  void loadMoreArticleEvent() async {
    final topicId = rxCurrentTopic.value?.id;
    if (topicId == null && rxIsEnd.isTrue) return;
    final List<PostModel> newPostList =
        await articlesApiProvider.getRelatedPostsByTopic(
            topicId: topicId!,
            skip: ArticlesApiProvider.articleTakeCount * listCountIndex,
            take: ArticlesApiProvider.articleTakeCount);
    listCountIndex++;
    if (newPostList.isEmpty)return ;
    if (newPostList.length < ArticlesApiProvider.articleTakeCount) {
      rxIsEnd.value = true;
    }
    rxRelatedPostList.addAll(newPostList);
    rxPageStatus.value = TopicPageStatus.normal;
  }

  // void fetchMoreTopicItems() async {
  //   if (isFeatured && repository.isNoMore) {
  //     isFeatured = false;
  //     topicItemList.addAll(await repository
  //         .fetchTopicItemList(_buildRecordUrl(), isLoadingFirstPage: true));
  //   } else {
  //     topicItemList.addAll(await repository.fetchNextPageTopicItemList(
  //       tagIdList: topic.tagIdList,
  //     ));
  //   }
  //   isNoMore.value = repository.isNoMore;
  // }



  // String _buildImageUrl() {
  //   return '${Environment().config.mirrorMediaDomain}/api/v2/images?where={"topics":{"\$in":["${topic.id}"]}}&max_results=25';
  // }

  // List<TopicItem> _sortByMap(List<TopicItem> items) {
  //   items.removeWhere((element) => element.tagId == null);
  //   if (topic.tagOrderMap != null && topic.tagOrderMap!.isNotEmpty) {
  //     items.sort((a, b) {
  //       if (topic.tagOrderMap!.containsKey(a.tagId) &&
  //           topic.tagOrderMap!.containsKey(b.tagId)) {
  //         int orderCompare = topic.tagOrderMap![a.tagId]!
  //             .compareTo(topic.tagOrderMap![b.tagId]!);
  //         if (orderCompare != 0) {
  //           return orderCompare;
  //         } else {
  //           return b.record.publishedDate.compareTo(a.record.publishedDate);
  //         }
  //       }
  //
  //       return b.record.publishedDate.compareTo(a.record.publishedDate);
  //     });
  //   } else {
  //     Map<String, int> tagOrderMap = {};
  //     int order = 0;
  //     for (var item in items) {
  //       tagOrderMap.putIfAbsent(item.tagId!, () => order);
  //       order++;
  //     }
  //     items.sort((a, b) {
  //       int orderCompare =
  //           tagOrderMap[a.tagId]!.compareTo(tagOrderMap[b.tagId]!);
  //       if (orderCompare != 0) {
  //         return orderCompare;
  //       }
  //
  //       return b.record.publishedDate.compareTo(a.record.publishedDate);
  //     });
  //   }
  //   return items;
  // }

  Future<void> _loadAds() async {
    String storyAdJsonFileLocation = GetPlatform.isIOS
        ? Environment().config.iOSStoryAdJsonLocation
        : Environment().config.androidStoryAdJsonLocation;
    String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
    final storyAdMaps = json.decode(storyAdString);
    rxStoryAd.value = StoryAd.fromJson(storyAdMaps['other']);
  }

  void debugLog(String s) {}
}
