import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/record.dart';

class RecordList extends CustomizedList<Record> {
  // constructor
  RecordList();

  factory RecordList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    RecordList objects = RecordList();
    List parseList = parsedJson.map((i) => Record.fromJson(i)).toList();
    parseList.forEach((element) {
      objects.add(element);
    });

    return objects;
  }

  factory RecordList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return RecordList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (Record object in l) {
      objects.add(object.toJson());
    }
    return objects;
  }

  String toJsonString() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (Record object in l) {
      objects.add(object.toJson());
    }
    return json.encode(objects);
  }
}
