import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/services/topicService.dart';

class TopicListController extends GetxController {
  final TopicRepos repository;
  TopicListController(this.repository);

  final topicList = <Topic>[].obs;
  final isLoadingMore = false.obs;
  final isNoMore = false.obs;
  late final StoryAd storyAd;

  @override
  void onInit() {
    super.onInit();
    fetchTopicList();
  }

  void fetchTopicList() async {
    try {
      await _loadAds();
      topicList.assignAll(await repository.fetchTopicList(
        Environment().config.topicListApi,
        isLoadingFirstPage: true,
      ));
    } catch (e) {
      print('Fetch Topic List Error: $e');
    }
  }

  void fetchMoreTopics() async {
    isLoadingMore.value = true;
    try {
      var newTopics = await repository.fetchNextPageTopicList();
      if (newTopics.isEmpty) {
        isNoMore.value = true;
      } else {
        topicList.addAll(newTopics);
      }
    } catch (e) {
      print('Fetch More Topic List Error: $e');
      Fluttertoast.showToast(
        msg: '加載更多失敗',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    isLoadingMore.value = false;
  }

  Future<void> _loadAds() async {
    String storyAdJsonFileLocation = GetPlatform.isIOS
        ? Environment().config.iOSStoryAdJsonLocation
        : Environment().config.androidStoryAdJsonLocation;
    String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
    final storyAdMaps = json.decode(storyAdString);
    storyAd = StoryAd.fromJson(storyAdMaps['other']);
  }
}
