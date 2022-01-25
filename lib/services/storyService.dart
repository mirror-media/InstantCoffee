import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/helpers/mMCacheManager.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/services/memberService.dart';

abstract class StoryRepos {
  Future<StoryRes> fetchStory(String slug, bool isMemberCheck);
}

class StoryService implements StoryRepos{
  MMCacheManager _mMCacheManager = MMCacheManager();
  ApiBaseHelper _helper = ApiBaseHelper();
  FirebaseAuth _auth= FirebaseAuth.instance;
  
  StoryService();

  String _getStoryApi(String slug, bool isMemberCheck) {
    if(isMemberCheck) {
      // this api will check member state before returning story data
      return Environment().config.storyPageApi +
          'getposts?where={"slug":"$slug","isAudioSiteOnly":false}&related=full';//&clean=content
    }

    // this api will return story data directly
    // if story is member only, it will only return part of the story data 
    return Environment().config.storyPageApi +
        'story?where={"slug":"$slug","isAudioSiteOnly":false}&related=full';//&clean=content
  }
  
  /// Check the file exists in cache first.
  /// If file exists, get the json file by cache,
  /// or get the json file from api,
  /// and check the json file is member only or not.
  /// If the json file is not member only, 
  /// save the file in cache.
  Future<StoryRes> fetchStory(String slug, bool isMemberCheck) async {
    String? token = await _auth.currentUser?.getIdToken();
    String endpoint = _getStoryApi(slug, isMemberCheck);

    bool isCacheFileExists = await _mMCacheManager.isFileExistsAndNotExpired(endpoint);
    var jsonResponse;
    Uint8List fileBytes = Uint8List(0);
    if(isCacheFileExists) {
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
        print('No Internet connection');
        throw FetchDataException('No Internet connection');
      } catch(e) {
        print('error: $e');
      }
      print('Api get done.');
    }

    StoryRes storyRes = StoryRes.fromJson(jsonResponse);
    if(!isCacheFileExists && 
      !Category.isMemberOnlyInCategoryList(storyRes.story.categories)) {
      // save cache file
      _mMCacheManager.putFile(
        endpoint, 
        fileBytes, 
        maxAge: storyCacheDuration, 
        fileExtension: 'json'
      );
    }
    return storyRes;
  }
}
