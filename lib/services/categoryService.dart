import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/category.dart';

abstract class CategoryRepos {
  Future<List<Category>> fetchCategoryList();
}

class CategoryService implements CategoryRepos {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Category>> fetchCategoryList() async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(Environment().config.sectionApi, maxAge: categoryCacheDuration);
    var sectionJson = jsonResponse["_items"];

    List<Category> categoryList = [];
    for (int i = 0; i < sectionJson.length; i++) {
      categoryList.addAll(Category.categoryListFromJson(sectionJson[i]['categories']));
    }

    return categoryList;
  }
}
