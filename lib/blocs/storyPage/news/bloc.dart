import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/news/events.dart';
import 'package:readr_app/blocs/storyPage/news/states.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/errorLogHelper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/services/storyService.dart';

class StoryBloc extends Bloc<StoryEvents, StoryState> {
  String storySlug;
  final StoryRepos storyRepos;

  StoryBloc({
    @required this.storySlug,
    @required this.storyRepos
  }) : super(StoryState.init());

  @override
  Stream<StoryState> mapEventToState(StoryEvents event) async* {
    ErrorLogHelper _errorLogHelper = ErrorLogHelper();
    
    if(event is FetchPublishedStoryBySlug) {
      print(event.toString());
      storySlug = event.slug;
      try{
        yield StoryState.loading();

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
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'No Internet',
        );
        yield StoryState.error(
          errorMessages: NoInternetException('No Internet'),
        );
      } on HttpException {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'No Service Found',
        );
        yield StoryState.error(
          errorMessages: NoServiceFoundException('No Service Found'),
        );
      } on FormatException {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'Invalid Response format',
        );
        yield StoryState.error(
          errorMessages: InvalidFormatException('Invalid Response format'),
        );
      } on FetchDataException {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'Error During Communication'
        );
        yield StoryState.error(
          errorMessages: NoInternetException('Error During Communication'),
        );
      } on BadRequestException {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'Invalid Request',
        );
        yield StoryState.error(
          errorMessages: Error400Exception('Invalid Request'),
        );
      } on UnauthorisedException {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'Unauthorised',
        );
        yield StoryState.error(
          errorMessages: Error400Exception('Unauthorised'),
        );
      } on InvalidInputException {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'Invalid Input',
        );
        yield StoryState.error(
          errorMessages: Error400Exception('Invalid Input'),
        );
      } on InternalServerErrorException {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          'Internal Server Error',
        );
        yield StoryState.error(
          errorMessages: NoServiceFoundException('Internal Server Error'),
        );
      } catch (e) {
        _errorLogHelper.record(
          event.eventName(),
          event.eventParameters(),
          e.toString(),
        );
        yield StoryState.error(
          errorMessages: UnknownException(e.toString()),
        );
      }
    }
  }

  String getShareUrlFromSlug() {
    return '${Environment().config.mirrorMediaDomain}/story/$storySlug/?utm_source=app&utm_medium=mmapp';
  }
}
