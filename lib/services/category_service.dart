import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/models/category.dart';

abstract class CategoryRepos {
  Future<List<Category>> fetchCategoryList();
}

class CategoryService implements CategoryRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final ArticlesApiProvider articlesApiProvider =Get.find();

  @override
  Future<List<Category>> fetchCategoryList() async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(
        Environment().config.sectionApi,
        maxAge: categoryCacheDuration);
    var sectionJson = jsonResponse["_items"];

    List<Category> categoryList = [];
    for (int i = 0; i < sectionJson.length; i++) {
      categoryList
          .addAll(Category.categoryListFromJson(sectionJson[i]['categories']));
    }

    return categoryList;
  }
}
