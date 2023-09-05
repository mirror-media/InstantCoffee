import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/record.dart';

abstract class RecordRepos {
  Future<List<Record>> fetchRecordList(String url,
      {bool isLoadingFirstPage = false});

  Future<List<Record>> fetchNextPageRecordList(String section);

  Future<List<Record>> fetchLatestNextPageRecordList();
}

class RecordService implements RecordRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();
  int _page = 1;
  final ArticlesApiProvider articlesApiProvider = Get.find();

  @override
  Future<List<Record>> fetchRecordList(String url,
      {bool isLoadingFirstPage = false}) async {
    if (isLoadingFirstPage) {
      _page = 1;
    }

    dynamic jsonResponse;
    if (_page <= 2) {
      jsonResponse = await _helper.getByCacheAndAutoCache(url,
          maxAge: contentTabCacheDuration);
    } else {
      jsonResponse = await _helper.getByUrl(url);
    }

    if (jsonResponse.containsKey("_links") &&
        jsonResponse["_links"].containsKey("next")) {
          Environment().config.apiBase + jsonResponse["_links"]["next"]["href"];
    } else {
    }

    dynamic jsonObject;
    if (jsonResponse.containsKey("_items")) {
      jsonObject = jsonResponse["_items"];
    } else if (jsonResponse.containsKey("report")) {
      jsonObject = jsonResponse["report"];
      // work around to get a clean slug string
      for (var item in jsonObject) {
        item['slug'] = item['slug'].replaceAll(RegExp(r'(story|/)'), '');
      }
    } else if (jsonResponse.containsKey("latest")) {
      jsonObject = jsonResponse["latest"];
    } else {
      jsonObject = [];
    }
    List<Record> records = Record.recordListFromJson(jsonObject);
    return records;
  }

  @override
  Future<List<Record>> fetchNextPageRecordList(String section) async {
    _page++;
    return await articlesApiProvider.getArticleListBySection(
        section: section, page: _page);
  }

  @override
  Future<List<Record>> fetchLatestNextPageRecordList() async {
    if (_page < 4) {
      _page++;
      return articlesApiProvider.getHomePageLatestArticleList(page: _page);
    }
    return [];
  }
}
