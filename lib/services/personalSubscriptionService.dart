import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/recordList.dart';

class PersonalSubscriptionService {
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  Future<RecordList> fetchRecordList(String categoryListJson, {int page = 1}) async {
    String url = env.baseConfig.apiBase +
        'meta?where={"categories":{"\$in":$categoryListJson},"device":{"\$in":["all","app"]}}' +
        '&page=$page&sort=-publishedDate&utm_source=app&utm_medium=news&max_results=20';

    final jsonResponse = await _helper.getByUrl(url);
    var jsonObject = jsonResponse['_items'];

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
