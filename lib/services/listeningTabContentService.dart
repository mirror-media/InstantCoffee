import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/record.dart';

class ListeningTabContentService {
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  String _nextPageUrl = '';
  String get getNextUrl => this._nextPageUrl;
  
  Future<List<Record>> fetchRecordList(String url) async {
    dynamic jsonResponse;
    if(page <= 2) {
      jsonResponse = await _helper.getByCacheAndAutoCache(url, maxAge: listeningTabContentCacheDuration);
    }
    else {
      jsonResponse = await _helper.getByUrl(url);
    }

    _nextPageUrl =
        Environment().config.listeningWidgetApi + '&pageToken=' + jsonResponse['nextPageToken'];
    List<Record> records = Record.recordListFromJson(jsonResponse['items']);
    return records;
  }

  int initialPage() {
    return this.page = 1;
  }

  int nextPage() {
    return ++ this.page;
  }
}
