import 'dart:convert';

import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/recordList.dart';

class RecordService {
  ApiBaseHelper _helper = ApiBaseHelper();

  String nextPage = '';

  Future<RecordList> fetchRecordList(String url) async {
    final jsonResponse = await _helper.getByUrl(url);
    var jsonObject;

    if (jsonResponse.containsKey("_links") &&
        jsonResponse["_links"].containsKey("next")) {
      this.nextPage = jsonResponse["_links"]["next"]["href"];
    } else {
      this.nextPage = '';
    }

    if (jsonResponse.containsKey("_items")) {
      jsonObject = jsonResponse["_items"];
    } else if (jsonResponse.containsKey("report")) {
      jsonObject = jsonResponse["report"];
      // work around to get a clean slug string
      for (var item in jsonObject) {
        item['slug'] = item['slug'].replaceAll(new RegExp(r'(story|/)'), '');
      }
      //
    } else {
      jsonObject = [];
    }
    RecordList records = new RecordList.fromJson(jsonObject);
    //await Future.delayed(Duration(seconds: 3));
    return records;
  }

  String getNext() {
    return this.nextPage;
  }
}
