import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/people.dart';

class PeopleList extends CustomizedList<People> {
  // constructor
  PeopleList();

  factory PeopleList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    PeopleList objects = PeopleList();
    List parseList = parsedJson.map((i) => People.fromJson(i)).toList();
    parseList.forEach((element) {
      objects.add(element);
    });

    return objects;
  }

  factory PeopleList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return PeopleList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (People object in l) {
      objects.add(object.toJson());
    }
    return objects;
  }

  String toJsonString() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (People object in l) {
      objects.add(object.toJson());
    }
    return json.encode(objects);
  }
}
