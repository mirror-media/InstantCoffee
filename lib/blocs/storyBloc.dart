import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

      String storyAdJsonFileLocation = Platform.isIOS
      ? 'assets/data/iOSStoryAd.json'
      : 'assets/data/androidStoryAd.json';
      // String storyAdJsonFileLocation = Platform.isIOS
      // ? 'assets/data/iOSTestStoryAd.json'
      // : 'assets/data/androidTestStoryAd.json';
      String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
      final storyAdMaps = json.decode(storyAdString);

      story.storyAd = StoryAd.fromJson(storyAdMaps['other']);
      for(int i=0; i<story.sections.length; i++) {
        String sectionName;
        if (story != null) {
          sectionName = story.getSectionName();
        }
        
        if(sectionName != null && storyAdMaps[sectionName] != null) {
          story.storyAd = StoryAd.fromJson(storyAdMaps[sectionName]);
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
    if (story != null) {
      sectionName = story.getSectionName();
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
