import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/record.dart';

import '../models/category.dart';

abstract class PersonalSubscriptionRepos {
  int initialPage();

  int nextPage();

  int previousPage();

  Future<List<Record>> fetchRecordList(List<Category> categoryList,
      {int page = 1});

  Future<List<Record>> fetchNextRecordList(List<Category> categoryList);
}

class PersonalSubscriptionService implements PersonalSubscriptionRepos {
  final ArticlesApiProvider articlesApiProvider = Get.find();
  int page = 1;

  @override
  int initialPage() {
    return page = 1;
  }

  @override
  int nextPage() {
    return page = page + 1;
  }

  @override
  int previousPage() {
    if (page == 1) {
      return 1;
    }

    return page = page - 1;
  }

  @override
  Future<List<Record>> fetchRecordList(List<Category> categoryList,
      {int page = 1}) async {
    List<Record> records = await articlesApiProvider
        .getArticleListByCategoryList(list: categoryList, page: page - 1);
    return records;
  }

  @override
  Future<List<Record>> fetchNextRecordList(List<Category> categoryList) async {
    nextPage();
    return await fetchRecordList(categoryList, page: page);
  }
}
