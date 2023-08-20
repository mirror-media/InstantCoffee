import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/storyPage/listening/states.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/app_exception.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/story_ad.dart';
import 'package:readr_app/services/listening_tab_content_service.dart';
import 'package:readr_app/services/listening_widget_service.dart';
import 'package:readr_app/widgets/logger.dart';

class ListeningStoryCubit extends Cubit<ListeningStoryState> with Logger {
  String storySlug;
  ListeningStoryCubit({
    required this.storySlug,
  }) : super(ListeningStoryInitState());
  final ArticlesApiProvider articlesApiProvider =Get.find();


  void fetchListeningStoryPageInfo(String slug) async {
    debugLog('Fetch listening story page info { slug: $slug }');
    storySlug = slug;
    emit(ListeningStoryLoading());
    try {
      ListeningWidgetService listeningWidgetService = ListeningWidgetService();
      ListeningTabContentService listeningTabContentService =
          ListeningTabContentService();
      Listening listening = await listeningWidgetService.fetchListening(slug);
      List<Record> recordList = await listeningTabContentService.fetchRecordList(
          '${Environment().config.listeningWidgetApi}youtube/search?maxResults=7&order=date&part=snippet&channelId=UCYkldEK001GxR884OZMFnRw');

      String storyAdJsonFileLocation = Platform.isIOS
          ? Environment().config.iOSStoryAdJsonLocation
          : Environment().config.androidStoryAdJsonLocation;
      // String storyAdJsonFileLocation = Platform.isIOS
      // ? 'assets/data/iOSTestStoryAd.json'
      // : 'assets/data/androidTestStoryAd.json';
      String storyAdString =
          await rootBundle.loadString(storyAdJsonFileLocation);
      final storyAdMaps = json.decode(storyAdString);

      listening.storyAd = StoryAd.fromJson(storyAdMaps['videohub']);

      emit(ListeningStoryLoaded(
        listening: listening,
        recordList: recordList,
      ));
    } on SocketException {
      emit(ListeningStoryError(error: NoInternetException('No Internet')));
    } on HttpException {
      emit(ListeningStoryError(
          error: NoServiceFoundException('No Service Found')));
    } on FormatException {
      emit(ListeningStoryError(
          error: InvalidFormatException('Invalid Response format')));
    } on FetchDataException {
      emit(ListeningStoryError(
          error: NoInternetException('Error During Communication')));
    } on BadRequestException {
      emit(ListeningStoryError(error: Error400Exception('Invalid Request')));
    } on UnauthorisedException {
      emit(ListeningStoryError(error: Error400Exception('Unauthorised')));
    } on InvalidInputException {
      emit(ListeningStoryError(error: Error400Exception('Invalid Input')));
    } on InternalServerErrorException {
      emit(ListeningStoryError(
          error: NoServiceFoundException('Internal Server Error')));
    } catch (e) {
      emit(ListeningStoryError(error: UnknownException(e.toString())));
    }
  }

  String getShareUrlFromSlug() {
    return '${Environment().config.mirrorMediaDomain}/video/$storySlug/?utm_source=app&utm_medium=mmapp';
  }
}
