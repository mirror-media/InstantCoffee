import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/app_exception.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/helpers/m_m_cache_manager.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/story_res.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

abstract class StoryRepos {
  Future<StoryRes> fetchStory(String slug, bool isMemberCheck);
}

class StoryService with Logger implements StoryRepos {
  final MMCacheManager _mMCacheManager = MMCacheManager();
  final ApiBaseHelper _helper = ApiBaseHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StoryService();

  String _getStoryApi(String slug, bool isMemberCheck) {
    if (isMemberCheck) {
      // this api will check member state before returning story data
      return '${Environment().config.storyPageApi}getposts?where={"slug":"$slug","isAudioSiteOnly":false}&related=full'; //&clean=content
    }

    // this api will return story data directly
    // if story is member only, it will only return part of the story data
    return '${Environment().config.storyPageApi}story?where={"slug":"$slug","isAudioSiteOnly":false}&related=full'; //&clean=content
  }

  /// Check the file exists in cache first.
  /// If file exists, get the json file by cache,
  /// or get the json file from api,
  /// and check the json file is member only or not.
  /// If the json file is not member only,
  /// save the file in cache.
  @override
  Future<StoryRes> fetchStory(String slug, bool isMemberCheck) async {
    String? token = await _auth.currentUser?.getIdToken();
    String endpoint = _getStoryApi(slug, isMemberCheck);

    bool isCacheFileExists =
        await _mMCacheManager.isFileExistsAndNotExpired(endpoint);
    dynamic jsonResponse;
    Uint8List fileBytes = Uint8List(0);
    if (isCacheFileExists) {
      jsonResponse = await _helper.getByCache(endpoint);
    } else {
      try {
        Uri uri = Uri.parse(endpoint);
        final response = await http.get(
          uri,
          headers: MemberService.getHeaders(token),
        );
        fileBytes = response.bodyBytes;
        jsonResponse = returnResponse(response);
      } on SocketException {
        debugLog('No Internet connection');
        throw FetchDataException('No Internet connection');
      } catch (e) {
        debugLog('error: $e');
      }
      debugLog('Api get done.');
    }

    StoryRes storyRes = StoryRes.fromJson(jsonResponse);
    if (!isCacheFileExists &&
        !Category.isMemberOnlyInCategoryList(storyRes.story.categories)) {
      // save cache file
      _mMCacheManager.putFile(endpoint, fileBytes,
          maxAge: storyCacheDuration, fileExtension: 'json');
    }
    return storyRes;
  }
}
