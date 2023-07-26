import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/topic_page_status.dart';

import '../../data/enum/topic_type.dart';
import '../../data/providers/articles_api_provider.dart';
import '../../helpers/environment.dart';
import '../../models/post/post.dart';
import '../../models/story_ad.dart';
import '../../models/topic.dart';
import '../../models/topic_image_item.dart';
import '../../models/topic_item.dart';
import '../../services/topic_service.dart';

class TopicPageController extends GetxController {
  late TopicRepos repository;
  final ArticlesApiProvider articlesApiProvider = ArticlesApiProvider();

  final Rxn<Topic> rxCurrentTopic = Rxn();
  final RxList<Post> rxRelatedPostList = RxList();
  final Rxn<StoryAd> rxStoryAd = Rxn();
  final Rx<TopicPageStatus> rxPageStatus =
      Rx<TopicPageStatus>(TopicPageStatus.normal);
  final RxBool rxIsEnd = false.obs;

  ScrollController scrollController = ScrollController(keepScrollOffset:true);

  int listCountIndex = 1;

  late Topic topic;

  final topicItemList = <TopicItem>[].obs;
  final List<TopicImageItem> portraitWallItemList = [];

  final isLoadingMore = false.obs;
  final isNoMore = false.obs;
  bool isFeatured = false;

  @override
  void onInit() {
    super.onInit();
    final argument = Get.arguments as Map<String, dynamic>;
    if (argument.containsKey('topic')) {
      rxCurrentTopic.value = argument['topic'];
    }
    repository = TopicService();
    topic = argument['topic'];
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
    // update();
    try {
      switch (topic.type) {
        case TopicType.slideshow:
        case TopicType.list:
          final topicId = rxCurrentTopic.value?.id;
          if (topicId == null) return;
          rxRelatedPostList.value = await articlesApiProvider
              .getRelatedPostsByTopic(topicId: topicId);
          rxPageStatus.value = TopicPageStatus.normal;
          // List<TopicItem> items = [];
          // isFeatured = true;
          // List<TopicItem> featuredList = await repository
          //     .fetchTopicItemList(_buildRecordUrl(), isLoadingFirstPage: true);
          // items.addAll(featuredList);
          // if (featuredList.isEmpty || repository.isNoMore) {
          //   isFeatured = false;
          //   List<TopicItem> notFeaturedList =
          //       await repository.fetchTopicItemList(_buildRecordUrl(),
          //           isLoadingFirstPage: true);
          //   items.addAll(notFeaturedList);
          // }
          // topicItemList.assignAll(items);
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

      rxPageStatus.value = TopicPageStatus.normal;
    } catch (e) {
      debugLog('Fetch topic story list error: $e');

      rxPageStatus.value = TopicPageStatus.error;
    }
    // update();
  }

  void loadMoreArticleEvent() async {
    final topicId = rxCurrentTopic.value?.id;
    if (topicId == null && rxIsEnd.isTrue) return;


    final List<Post> newPostList =
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
    return '${Environment().config.mirrorMediaDomain}/apimbership/v0/getposts?max_results=12&where={"isFeatured":$isFeatured,"topics":{"\$in":["${topic.id}"]}}&sort=-publishedDate&page=1';
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
