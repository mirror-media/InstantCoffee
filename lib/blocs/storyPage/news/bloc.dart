import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/news/events.dart';
import 'package:readr_app/blocs/storyPage/news/states.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/errorLogHelper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/services/storyService.dart';

class StoryBloc extends Bloc<StoryEvents, StoryState> {
  final StoryRepos storyRepos;
  StoryBloc({
    required String storySlug,
    required this.storyRepos
  }) : super(StoryState.init(storySlug: storySlug)) {
    on<FetchPublishedStoryBySlug>(_fetchPublishedStoryBySlug);
  }

  ErrorLogHelper _errorLogHelper = ErrorLogHelper();

  _fetchPublishedStoryBySlug(
    FetchPublishedStoryBySlug event,
    Emitter<StoryState> emit,
  ) async{
    print(event.toString());

    try{
      emit(StoryState.loading(storySlug: event.slug));

      StoryRes storyRes = await storyRepos.fetchStory(
        event.slug, 
        event.isMemberCheck
      );
      Story story = storyRes.story;
      
      String storyAdJsonFileLocation = Platform.isIOS
      ? Environment().config.iOSStoryAdJsonLocation
      : Environment().config.androidStoryAdJsonLocation;
      // String storyAdJsonFileLocation = Platform.isIOS
      // ? 'assets/data/iOSTestStoryAd.json'
      // : 'assets/data/androidTestStoryAd.json';
      String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
      final storyAdMaps = json.decode(storyAdString);

      story.storyAd = StoryAd.fromJson(storyAdMaps['other']);
      for(int i=0; i<story.sections.length; i++) {
        String? sectionName = story.getSectionName();
        
        if(sectionName != null && storyAdMaps[sectionName] != null) {
          story.storyAd = StoryAd.fromJson(storyAdMaps[sectionName]);
          break;
        }
      }

      emit(StoryState.loaded(
        storySlug: event.slug, 
        storyRes: storyRes
      ));
    } catch (e) {
      _errorLogHelper.record(
        event.eventName(),
        event.eventParameters(),
        e.toString(),
      );
      emit(StoryState.error(
        storySlug: event.slug, 
        errorMessages: UnknownException(e.toString())
      ));
    }
  }

  String getShareUrlFromSlug() {
    return '${Environment().config.mirrorMediaDomain}/story/${state.storySlug}/?utm_source=app&utm_medium=mmapp';
  }
}
