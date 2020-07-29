import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/tag.dart';

class TagList extends CustomizedList<Tag> {
  // constructor
  TagList();

  factory TagList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    TagList objects = TagList();
    List parseList = parsedJson.map((i) => Tag.fromJson(i)).toList();
    parseList.forEach((element) {
      objects.add(element);
    });

    return objects;
  }

  factory TagList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return TagList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (Tag object in l) {
      objects.add(object.toJson());
    }
    return objects;
  }

  String toJsonString() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (Tag object in l) {
      objects.add(object.toJson());
    }
    return json.encode(objects);
  }
}
