import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/recordList.dart';

class ListeningTabContentService {
  ApiBaseHelper _helper = ApiBaseHelper();

  String nextPage = '';

  Future<RecordList> fetchRecordList(String url) async {
    final jsonResponse = await _helper.getByUrl(url);
    var jsonObject = jsonResponse['items'];
    nextPage =
        listeningWidgetApi + '&pageToken=' + jsonResponse['nextPageToken'];
    RecordList records = RecordList.fromJson(jsonObject);
    return records;
  }

  String getNext() {
    return this.nextPage;
  }
}
