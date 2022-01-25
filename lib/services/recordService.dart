import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/record.dart';

class RecordService {
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  String _nextPageUrl = '';
  String get getNextUrl => this._nextPageUrl;

  Future<List<Record>> fetchRecordList(String url) async {
    dynamic jsonResponse;
    if(page <= 2) {
      jsonResponse = await _helper.getByCacheAndAutoCache(url, maxAge: contentTabCacheDuration);
    }
    else {
      jsonResponse = await _helper.getByUrl(url);
    }
    
    if (jsonResponse.containsKey("_links") &&
        jsonResponse["_links"].containsKey("next")) {
      this._nextPageUrl = Environment().config.apiBase + jsonResponse["_links"]["next"]["href"];
    } else {
      this._nextPageUrl = '';
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

  int initialPage() {
    return this.page = 1;
  }

  int nextPage() {
    return ++ this.page;
  }
}
