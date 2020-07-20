import 'RecordList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordService {
  String nextPage = '';

  Future<String> _loadLatestsAsset(String endpoint) async {
    //return await rootBundle.loadString('assets/data/records.json');
    final response = await http.get(endpoint);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "{'status': 'error', 'message': 'API return error'}";
    }
  }

  Future<RecordList> loadLatests(String endpoint) async {
    String jsonString = await _loadLatestsAsset(endpoint);
    final jsonResponse = json.decode(jsonString);
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
    return records;
  }

  String getNext() {
    return this.nextPage;
  }
}
