import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/story.dart';

class StoryService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<Story> fetchStoryList(String slug) async {
    String endpoint = apiBase +
        'posts?where={"slug":"' +
        slug +
        '","isAudioSiteOnly":false' +
        '}&related=full&clean=content';

    final jsonResponse = await _helper.getByUrl(endpoint);
    Story story = new Story.fromJson(jsonResponse["_items"][0]);
    return story;
  }
}
