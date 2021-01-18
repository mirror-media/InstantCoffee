import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/storyRes.dart';

class StoryService {
  ApiBaseHelper _helper;
  FirebaseAuth _auth;
  
  StoryService() {
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

    final jsonResponse = await _helper.getByCache(
      endpoint,
      headers: {
        'Cache-control': 'no-cache',
        "Authorization": "Bearer $token"
      },
      maxAge: storyCacheDuration
    );
    StoryRes storyRes = StoryRes.fromJson(jsonResponse);
    return storyRes;
  }
}
