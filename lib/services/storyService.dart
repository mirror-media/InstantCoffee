import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/helpers/mMCacheManager.dart';
import 'package:readr_app/models/storyRes.dart';

class StoryService {
  MMCacheManager _mMCacheManager;
  ApiBaseHelper _helper;
  FirebaseAuth _auth;
  
  StoryService() {
    _mMCacheManager = MMCacheManager();
    _helper = ApiBaseHelper();
    _auth = FirebaseAuth.instance;
  }
  
  Future<StoryRes> fetchStory(String slug) async {
    String token = await _auth?.currentUser?.getIdToken();
    String endpoint = env.baseConfig.storyPageApi +
        'posts?where={"slug":"' +
        slug +
        '","isAudioSiteOnly":false' +
        '}&related=full';
    //&clean=content

    bool isCacheFileExists = await _mMCacheManager.isFileExistsAndNotExpired(endpoint);
    var jsonResponse;
    Uint8List fileBytes;
    if(isCacheFileExists) {
      jsonResponse = await _helper.getByCache(endpoint);
    } else {
      try {
        final response = await http.get(
          endpoint, 
          headers: {
            'Cache-control': 'no-cache',
            "Authorization": "Bearer $token"
          },
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
    if(!isCacheFileExists && !storyRes.story.categories.isMemberOnly()) {
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
