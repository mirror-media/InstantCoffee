import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/externalStory.dart';

abstract class ExternalStoryRepos {
  Future<ExternalStory> fetchStory(String slug);
}

class ExternalStoryService implements ExternalStoryRepos {
  ApiBaseHelper _helper = ApiBaseHelper();
  
  Future<ExternalStory> fetchStory(String slug) async {
    String url = Environment().config.externalStoryPageApi + '?where={"name":{"\$in":["$slug"]}}';
    dynamic jsonResponse = await _helper.getByUrl(url);
    ExternalStory externalStory = ExternalStory.fromJson(jsonResponse['_items'][0]);
    return externalStory;
  }
}