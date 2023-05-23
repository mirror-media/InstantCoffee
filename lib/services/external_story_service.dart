import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/external_story.dart';

abstract class ExternalStoryRepos {
  Future<ExternalStory> fetchStory(String slug);
}

class ExternalStoryService implements ExternalStoryRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<ExternalStory> fetchStory(String slug) async {
    String url =
        '${Environment().config.externalStoryPageApi}?where={"name":{"\$in":["$slug"]}}';
    dynamic jsonResponse = await _helper.getByUrl(url);
    ExternalStory externalStory =
        ExternalStory.fromJson(jsonResponse['_items'][0]);
    return externalStory;
  }
}
