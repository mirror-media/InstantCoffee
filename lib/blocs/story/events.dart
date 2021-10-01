import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:readr_app/blocs/story/states.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/services/storyService.dart';

abstract class StoryEvents{
  Stream<StoryState> run(StoryRepos storyRepos);
}

class FetchPublishedStoryBySlug extends StoryEvents {
  final String slug;
  final bool isMemberCheck;
  FetchPublishedStoryBySlug(
    this.slug,
    this.isMemberCheck
  );

  @override
  String toString() => 'FetchPublishedStoryBySlug { storySlug: $slug, isMemberCheck: $isMemberCheck }';

  @override
  Stream<StoryState> run(StoryRepos storyRepos) async*{
    print(this.toString());
    try{
      yield StoryLoading();
      StoryRes storyRes = await storyRepos.fetchStory(slug, isMemberCheck);
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
      yield StoryLoaded(storyRes: storyRes);
    } on SocketException {
      yield StoryError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield StoryError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield StoryError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } on FetchDataException {
      yield StoryError(
        error: NoInternetException('Error During Communication'),
      );
    } on BadRequestException {
      yield StoryError(
        error: Error400Exception('Invalid Request'),
      );
    } on UnauthorisedException {
      yield StoryError(
        error: Error400Exception('Unauthorised'),
      );
    } on InvalidInputException {
      yield StoryError(
        error: Error400Exception('Invalid Input'),
      );
    } on InternalServerErrorException {
      yield StoryError(
        error: NoServiceFoundException('Internal Server Error'),
      );
    } catch (e) {
      yield StoryError(
        error: UnknownException(e.toString()),
      );
    }
  }
}