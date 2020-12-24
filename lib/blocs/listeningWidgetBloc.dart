import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/services/listeningTabContentService.dart';
import 'package:readr_app/services/listeningWidgetService.dart';
import 'package:readr_app/models/recordList.dart';

class ListeningWidgetBloc {
  ListeningWidgetService _listeningWidgetService;
  ListeningTabContentService _listeningTabContentService;

  StreamController _listeningWidgetController;

  StreamSink<ApiResponse<TabContentState>> get listeningWidgetSink =>
      _listeningWidgetController.sink;

  Stream<ApiResponse<TabContentState>> get listeningWidgetStream =>
      _listeningWidgetController.stream;

  ListeningWidgetBloc(String slug) {
    _listeningWidgetService = ListeningWidgetService();
    _listeningTabContentService = ListeningTabContentService();
    _listeningWidgetController =
        StreamController<ApiResponse<TabContentState>>();
    fetchListening(slug);
  }

  sinkToAdd(ApiResponse<TabContentState> value) {
    if (!_listeningWidgetController.isClosed) {
      listeningWidgetSink.add(value);
    }
  }

  fetchListening(String slug) async {
    sinkToAdd(ApiResponse.loading('Fetching listeningWidget page'));

    try {
      Listening listening = await _listeningWidgetService.fetchListening(slug);
      RecordList recordList = await _listeningTabContentService.fetchRecordList(
          env.baseConfig.apiBase +
              'youtube/search?maxResults=7&order=date&part=snippet&channelId=UCYkldEK001GxR884OZMFnRw');

      String storyAdJsonFileLocation = Platform.isIOS
      ? 'assets/data/iOSStoryAd.json'
      : 'assets/data/androidStoryAd.json';
      // String storyAdJsonFileLocation = Platform.isIOS
      // ? 'assets/data/iOSTestStoryAd.json'
      // : 'assets/data/androidTestStoryAd.json';
      String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
      final storyAdMaps = json.decode(storyAdString);

      listening.storyAd = StoryAd.fromJson(storyAdMaps['videohub']);
      
      sinkToAdd(ApiResponse.completed(
          TabContentState(listening: listening, recordList: recordList)));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _listeningWidgetController?.close();
  }
}

class TabContentState {
  final Listening listening;
  final RecordList recordList;

  TabContentState({
    this.listening,
    this.recordList,
  });
}
