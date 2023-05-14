import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/models/record.dart';

abstract class RecordRepos {
  Future<List<Record>> fetchRecordList(String url,
      {bool isLoadingFirstPage = false});
  Future<List<Record>> fetchNextPageRecordList();
  Future<List<Record>> fetchLatestNextPageRecordList();
}

class RecordService implements RecordRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();
  int _page = 1;
  String _nextPageUrl = '';

  @override
  Future<List<Record>> fetchRecordList(String url,
      {bool isLoadingFirstPage = false}) async {
    if (isLoadingFirstPage) {
      _page = 1;
      _nextPageUrl = '';
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
      _nextPageUrl =
          Environment().config.apiBase + jsonResponse["_links"]["next"]["href"];
    } else {
      _nextPageUrl = '';
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
  Future<List<Record>> fetchNextPageRecordList() async {
    if (_nextPageUrl != '') {
      _page++;
      return await fetchRecordList(_nextPageUrl);
    }

    return [];
  }

  @override
  Future<List<Record>> fetchLatestNextPageRecordList() async {
    if (_page < 4) {
      _page++;
      _nextPageUrl =
          '${Environment().config.latestApi}post_external0$_page.json';
      return await fetchRecordList(_nextPageUrl);
    }

    return [];
  }
}
