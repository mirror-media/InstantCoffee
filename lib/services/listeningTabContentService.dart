import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/apiConstants.dart';
import 'package:readr_app/models/recordList.dart';

class ListeningTabContentService {
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  String _nextPageUrl = '';
  String get getNextUrl => this._nextPageUrl;
  
  Future<RecordList> fetchRecordList(String url) async {
    final jsonResponse = await _helper.getByUrl(url);
    var jsonObject = jsonResponse['items'];
    _nextPageUrl =
        listeningWidgetApi + '&pageToken=' + jsonResponse['nextPageToken'];
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
