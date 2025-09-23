import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/storyPage/news/events.dart';
import 'package:readr_app/blocs/storyPage/news/states.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/error_log_helper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/share_helper.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/story_ad.dart';
import 'package:readr_app/models/story_res.dart';
import 'package:readr_app/services/story_service.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';

export 'events.dart';
export 'states.dart';

class StoryBloc extends Bloc<StoryEvents, StoryState> with Logger {
  final StoryRepos storyRepos;
  StoryBloc({required String storySlug, required this.storyRepos})
      : super(StoryState.init(storySlug: storySlug)) {
    on<FetchPublishedStoryBySlug>(_fetchPublishedStoryBySlug);
  }

  final ErrorLogHelper _errorLogHelper = ErrorLogHelper();
  final ArticlesApiProvider articlesApiProvider = Get.find();
  _fetchPublishedStoryBySlug(
    FetchPublishedStoryBySlug event,
    Emitter<StoryState> emit,
  ) async {
    debugLog(event.toString());

    try {
      emit(StoryState.loading(storySlug: event.slug));

      StoryRes? storyRes =
          await articlesApiProvider.getArticleInfoBySlug(slug: event.slug);
      if (storyRes != null) {
        Story story = storyRes.story;

        // 檢查 isFreePremium 功能
        try {
          final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
          if (remoteConfigHelper.isFreePremium &&
              story.isTruncated &&
              story.trimmedApiData.isNotEmpty) {
            // 當 isFreePremium=true 且文章被截斷時，使用完整內容
            story.apiData = List.from(story.trimmedApiData);
            story.isTruncated = false;
          }
        } catch (e) {
          // RemoteConfig 未初始化時跳過，使用預設邏輯
          debugLog('RemoteConfig not ready in StoryBloc: $e');
        }

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
      }
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

  Future<void> shareStory({GlobalKey? shareButtonKey}) async {
    String shareUrl = getShareUrlFromSlug();

    await ShareHelper.shareWithPosition(
      text: shareUrl,
      buttonKey: shareButtonKey,
    );
  }
}
