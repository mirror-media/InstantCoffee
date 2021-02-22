import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/categoryList.dart';

class CategoryService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<CategoryList> fetchCategoryList() async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(env.baseConfig.sectionAPI, maxAge: categoryCacheDuration);
    var sectionJson = jsonResponse["_items"];

    CategoryList categoryList = CategoryList();
    for (int i = 0; i < sectionJson.length; i++) {
      categoryList.addAll(CategoryList.fromJson(sectionJson[i]['categories']));
    }

    return categoryList;
  }
}
