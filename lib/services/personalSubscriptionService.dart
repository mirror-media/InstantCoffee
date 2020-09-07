import 'dart:convert';

import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/apiConstants.dart';
import 'package:readr_app/models/categoryList.dart';
import 'package:readr_app/models/recordList.dart';

class PersonalSubscriptionService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RecordList> fetchRecordList(
      int pageCount, CategoryList categoryList) async {
    String categoryListJson =
        json.encode(categoryList.getSubscriptionIdStringList);
    String url = apiBase +
        'meta?where={"categories":{"\$in":$categoryListJson},"device":{"\$in":["all","app"]}}' +
        '&page=$pageCount&sort=-publishedDate&utm_source=app&utm_medium=news&max_results=20';

    final jsonResponse = await _helper.getByUrl(url);
    var jsonObject = jsonResponse['_items'];

    RecordList records = RecordList.fromJson(jsonObject);
    return records;
  }
}
