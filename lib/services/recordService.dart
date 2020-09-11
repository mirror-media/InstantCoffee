import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/apiConstants.dart';
import 'package:readr_app/models/recordList.dart';

class RecordService {
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  String _nextPageUrl = '';
  String get getNextUrl => this._nextPageUrl;

  Future<RecordList> fetchRecordList(String url) async {
    final jsonResponse = await _helper.getByUrl(url);
    var jsonObject;

    if (jsonResponse.containsKey("_links") &&
        jsonResponse["_links"].containsKey("next")) {
      this._nextPageUrl = apiBase + jsonResponse["_links"]["next"]["href"];
    } else {
      this._nextPageUrl = '';
    }

    if (jsonResponse.containsKey("_items")) {
      jsonObject = jsonResponse["_items"];
    } else if (jsonResponse.containsKey("report")) {
      jsonObject = jsonResponse["report"];
      // work around to get a clean slug string
      for (var item in jsonObject) {
        item['slug'] = item['slug'].replaceAll(RegExp(r'(story|/)'), '');
      }
      //
    } else {
      jsonObject = [];
    }
    RecordList records = RecordList.fromJson(jsonObject);
    return records;
  }

  int initialPage() {
    return this.page = 1;
  }

  int nextPage() {
    return ++ this.page;
  }
}
