import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/services/storyService.dart';

class StoryBloc {
  StoryService _storyService;

  StreamController _storyController;

  StreamSink<ApiResponse<Story>> get storySink => _storyController.sink;

  Stream<ApiResponse<Story>> get storyStream => _storyController.stream;

  StoryBloc(String slug) {
    _storyService = StoryService();
    _storyController = StreamController<ApiResponse<Story>>();
    fetchStory(slug);
  }

  sinkToAdd(ApiResponse<Story> value) {
    if (!_storyController.isClosed) {
      storySink.add(value);
    }
  }

  fetchStory(String slug) async {
    sinkToAdd(ApiResponse.loading('Fetching Story page'));

    try {
      Story story = await _storyService.fetchStory(slug);

      // String storyAdJsonFileLocation = Platform.isIOS
      // ? 'assets/data/iosStoryAd.json'
      // : 'assets/data/androidStoryAd.json';
      String storyAdJsonFileLocation = 'assets/data/defaultTestStoryAd.json';
      String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
      final storyAdMaps = json.decode(storyAdString);

      story.storyAd = StoryAd.fromJson(storyAdMaps['other']);
      for(int i=0; i<story.sections.length; i++) {
        if(storyAdMaps[story.sections[i].key] != null) {
          story.storyAd = StoryAd.fromJson(storyAdMaps[story.sections[i].key]);
          break;
        }
      }

      sinkToAdd(ApiResponse.completed(story));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  Color getSectionColor(Story story) {
    String sectionName;
    if (story != null && story.sections.length > 0) {
      sectionName = story.sections[0]?.name;
    }

    if (sectionColorMaps.containsKey(sectionName)) {
      return Color(sectionColorMaps[sectionName]);
    }

    return appColor;
  }

  dispose() {
    _storyController?.close();
  }
}
