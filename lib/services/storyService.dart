import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/apiConstants.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/story.dart';

class StoryService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Story> fetchStory(String slug) async {
    String endpoint = apiBase +
        'posts?where={"slug":"' +
        slug +
        '","isAudioSiteOnly":false' +
        '}&related=full';
    //&clean=content

    final jsonResponse = await _helper.getByCache(endpoint, maxAge: storyCacheDuration);
    Story story = new Story.fromJson(jsonResponse["_items"][0]);
    return story;
  }
}
