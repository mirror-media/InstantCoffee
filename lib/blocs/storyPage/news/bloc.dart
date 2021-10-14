import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/news/events.dart';
import 'package:readr_app/blocs/storyPage/news/states.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/services/storyService.dart';

class StoryBloc extends Bloc<StoryEvents, StoryState> {
  final StoryRepos storyRepos;

  StoryBloc({this.storyRepos}) : super(StoryState.init());

  @override
  Stream<StoryState> mapEventToState(StoryEvents event) async* {
    if(event is FetchPublishedStoryBySlug) {
      print(event.toString());
      try{
        yield StoryState.loading();

        StoryRes storyRes = await storyRepos.fetchStory(
          event.slug, 
          event.isMemberCheck
        );
        Story story = storyRes.story;
        
        String storyAdJsonFileLocation = Platform.isIOS
        ? env.baseConfig.iOSStoryAdJsonLocation
        : env.baseConfig.androidStoryAdJsonLocation;
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

        yield StoryState.loaded(
          storyRes: storyRes,
        );
      } on SocketException {
        yield StoryState.error(
          errorMessages: NoInternetException('No Internet'),
        );
      } on HttpException {
        yield StoryState.error(
          errorMessages: NoServiceFoundException('No Service Found'),
        );
      } on FormatException {
        yield StoryState.error(
          errorMessages: InvalidFormatException('Invalid Response format'),
        );
      } on FetchDataException {
        yield StoryState.error(
          errorMessages: NoInternetException('Error During Communication'),
        );
      } on BadRequestException {
        yield StoryState.error(
          errorMessages: Error400Exception('Invalid Request'),
        );
      } on UnauthorisedException {
        yield StoryState.error(
          errorMessages: Error400Exception('Unauthorised'),
        );
      } on InvalidInputException {
        yield StoryState.error(
          errorMessages: Error400Exception('Invalid Input'),
        );
      } on InternalServerErrorException {
        yield StoryState.error(
          errorMessages: NoServiceFoundException('Internal Server Error'),
        );
      } catch (e) {
        yield StoryState.error(
          errorMessages: UnknownException(e.toString()),
        );
      }
    }
  }
}
