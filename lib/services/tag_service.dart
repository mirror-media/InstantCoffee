import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/record_list_and_all_count.dart';

class TagService {
  final ArticlesApiProvider articlesApiProvider = Get.find();
  int page = 1;
  String _nextPageUrl = '';

  String get getNextUrl => _nextPageUrl;

  Future<RecordListAndAllCount> fetchRecordList(String tagId) async {
    return await articlesApiProvider.getArticleListByTag(
        tag: tagId, page: page-1);
  }

  int initialPage() {
    return page = 1;
  }

  int nextPage() {
    return ++page;
  }
}
