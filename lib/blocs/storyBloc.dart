import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/story.dart';
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
