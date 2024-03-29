import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/story_ad.dart';
import 'package:readr_app/models/topic/topic_model.dart';
import 'package:readr_app/widgets/logger.dart';

class TopicListController extends GetxController with Logger {
  final RxList<TopicModel> rxTopicList = RxList<TopicModel>();
  final ArticlesApiProvider articlesApiProvider = Get.find();
  static const defaultTopicCount = 12;
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  int listCountIndex = 1;
  RxBool rxIsEnd = false.obs;

  String loadFail ='加載更多失敗';
  String loadSuccessful = '加載成功 %d筆';

  final isLoadingMore = false.obs;
  final isNoMore = false.obs;
  final Rxn<StoryAd> rxnStoryAd =Rxn();

  @override
  void onInit() {
    super.onInit();
    _loadAds();
    fetchTopicList();
    scrollController.addListener(scrollEvent);
  }

  void fetchTopicList() async {
    try {
      rxTopicList.value =
          await articlesApiProvider.getTopicTabList(take: defaultTopicCount) ??
              [];
    } catch (e) {
      debugLog('Fetch Topic List Error: $e');
    }
  }

  void scrollEvent() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreTopics();
    }
  }

  void loadMoreTopics() async {
    if (rxIsEnd.isTrue) {
      displayToast(loadFail);
      return;
    }
    final List<TopicModel> newTopicList =
        await articlesApiProvider.getTopicTabList(
                take: defaultTopicCount,
                skip: listCountIndex * defaultTopicCount) ??
            [];
    listCountIndex++;
    if (newTopicList.isEmpty) {
      rxIsEnd.value = true;
      displayToast(loadFail);
    }
    if (newTopicList.length < defaultTopicCount) {
      rxIsEnd.value = true;
    }
    // displayToast(loadSuccessful.format([newTopicList.length]));
    rxTopicList.addAll(newTopicList);
  }

  void displayToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _loadAds() async {
    String storyAdJsonFileLocation = GetPlatform.isIOS
        ? Environment().config.iOSStoryAdJsonLocation
        : Environment().config.androidStoryAdJsonLocation;
    String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
    final storyAdMaps = json.decode(storyAdString);
    rxnStoryAd.value = StoryAd.fromJson(storyAdMaps['other']);

  }
}
