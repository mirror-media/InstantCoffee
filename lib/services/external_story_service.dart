import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/external_story.dart';

abstract class ExternalStoryRepos {
  Future<ExternalStory> fetchStory(String slug);
}

class ExternalStoryService implements ExternalStoryRepos {

  final ArticlesApiProvider articlesApiProvider =Get.find ();

  @override
  Future<ExternalStory> fetchStory(String slug) async {
    return await articlesApiProvider.getExternalArticleBySlug(slug: slug);
  }
}
