import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/record.dart';

class RecordList extends CustomizedList<Record> {
  int allRecordCount = 0;
  // constructor
  RecordList();

  factory RecordList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    RecordList records = RecordList();
    List parseList = parsedJson.map((i) => Record.fromJson(i)).toList();
    parseList.forEach((element) {
      records.add(element);
    });

    return records;
  }

  factory RecordList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return RecordList.fromJson(jsonData);
  }

  // your custom methods
  RecordList filterDuplicatedSlug() {
    RecordList records = RecordList();
    l.forEach((element) { 
      if(!records.contains(element)) {
        records.add(element);
      }
    });
    return records;
  }

  RecordList filterDuplicatedSlugByAnother(RecordList another) {
    RecordList records = RecordList();
    l.forEach((element) { 
      if(!another.contains(element)) {
        records.add(element);
      }
    });
    return records;
  }

  List<Map<dynamic, dynamic>> toJson() {
    List<Map> recordMaps = List();
    if (l == null) {
      return null;
    }

    for (Record record in l) {
      recordMaps.add(record.toJson());
    }
    return recordMaps;
  }

  String toJsonString() {
    List<Map> recordMaps = List();
    if (l == null) {
      return null;
    }

    for (Record record in l) {
      recordMaps.add(record.toJson());
    }
    return json.encode(recordMaps);
  }
}
