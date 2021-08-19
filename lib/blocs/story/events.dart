import 'dart:io';

import 'package:readr_app/blocs/story/states.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/services/storyService.dart';

abstract class StoryEvents{
  Stream<StoryState> run(StoryRepos storyRepos);
}

class FetchPublishedStoryBySlug extends StoryEvents {
  final String slug;
  FetchPublishedStoryBySlug(this.slug);

  @override
  String toString() => 'FetchPublishedStoryBySlug { storySlug: $slug }';

  @override
  Stream<StoryState> run(StoryRepos storyRepos) async*{
    print(this.toString());
    try{
      yield StoryLoading();
      StoryRes storyRes = await storyRepos.fetchStory(slug);
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