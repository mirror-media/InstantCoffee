import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/record.dart';

abstract class RecordRepos {
  Future<List<Record>> fetchRecordList(String url, {bool isLoadingFirstPage = false});
  Future<List<Record>> fetchNextPageRecordList();
}

class RecordService implements RecordRepos {
  ApiBaseHelper _helper = ApiBaseHelper();
  int _page = 1;
  String _nextPageUrl = '';

  @override
  Future<List<Record>> fetchRecordList(
    String url,
    {
      bool isLoadingFirstPage = false
    }
  ) async{
    if(isLoadingFirstPage) {
      _page = 1;
      _nextPageUrl = '';
    }

    dynamic jsonResponse;
    if(_page <= 2) {
      jsonResponse = await _helper.getByCacheAndAutoCache(url, maxAge: contentTabCacheDuration);
    }
    else {
      jsonResponse = await _helper.getByUrl(url);
    }
    
    if (jsonResponse.containsKey("_links") &&
        jsonResponse["_links"].containsKey("next")) {
      _nextPageUrl = Environment().config.apiBase + jsonResponse["_links"]["next"]["href"];
    } else {
      _nextPageUrl = '';
    }

    var jsonObject;
    if (jsonResponse.containsKey("_items")) {
      jsonObject = jsonResponse["_items"];
    } else if (jsonResponse.containsKey("report")) {
      jsonObject = jsonResponse["report"];
      // work around to get a clean slug string
      for (var item in jsonObject) {
        item['slug'] = item['slug'].replaceAll(RegExp(r'(story|/)'), '');
      }
    } else {
      jsonObject = [];
    }
    List<Record> records = Record.recordListFromJson(jsonObject);
    return records;
  }

  @override
  Future<List<Record>> fetchNextPageRecordList() async{
    if(_nextPageUrl != '') {
      _page ++;
      return await fetchRecordList(_nextPageUrl);
    }

    return [];
  }
}