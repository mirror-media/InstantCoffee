import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/news/events.dart';
import 'package:readr_app/blocs/storyPage/news/states.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/error_log_helper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/story_ad.dart';
import 'package:readr_app/models/story_res.dart';
import 'package:readr_app/services/story_service.dart';
import 'package:readr_app/widgets/logger.dart';

export 'events.dart';
export 'states.dart';

class StoryBloc extends Bloc<StoryEvents, StoryState> with Logger {
  final StoryRepos storyRepos;
  StoryBloc({required String storySlug, required this.storyRepos})
      : super(StoryState.init(storySlug: storySlug)) {
    on<FetchPublishedStoryBySlug>(_fetchPublishedStoryBySlug);
  }

  final ErrorLogHelper _errorLogHelper = ErrorLogHelper();

  _fetchPublishedStoryBySlug(
    FetchPublishedStoryBySlug event,
    Emitter<StoryState> emit,
  ) async {
    debugLog(event.toString());

    try {
      emit(StoryState.loading(storySlug: event.slug));

      StoryRes storyRes =
          await storyRepos.fetchStory(event.slug, event.isMemberCheck);
      Story story = storyRes.story;

      String storyAdJsonFileLocation = Platform.isIOS
          ? Environment().config.iOSStoryAdJsonLocation
          : Environment().config.androidStoryAdJsonLocation;
      // String storyAdJsonFileLocation = Platform.isIOS
      // ? 'assets/data/iOSTestStoryAd.json'
      // : 'assets/data/androidTestStoryAd.json';
      String storyAdString =
          await rootBundle.loadString(storyAdJsonFileLocation);
      final storyAdMaps = json.decode(storyAdString);

      story.storyAd = StoryAd.fromJson(storyAdMaps['other']);
      for (int i = 0; i < story.sections.length; i++) {
        String? sectionName = story.getSectionName();

        if (sectionName != null && storyAdMaps[sectionName] != null) {
          story.storyAd = StoryAd.fromJson(storyAdMaps[sectionName]);
          break;
        }
      }

      emit(StoryState.loaded(storySlug: event.slug, storyRes: storyRes));
    } catch (e, s) {
      _errorLogHelper.record(e, s);
      emit(StoryState.error(
          storySlug: event.slug,
          errorMessages: UnknownException(e.toString())));
    }
  }

  String get currentStorySlug => state.storySlug;

  String getShareUrlFromSlug() {
    return '${Environment().config.mirrorMediaDomain}/story/$currentStorySlug/?utm_source=app&utm_medium=mmapp';
  }
}
