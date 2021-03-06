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

    TagList tags = TagList();
    List parseList = parsedJson.map((i) => Tag.fromJson(i)).toList();
    parseList.forEach((element) {
      tags.add(element);
    });

    return tags;
  }

  factory TagList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return TagList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> tagMaps = List();
    if (l == null) {
      return null;
    }

    for (Tag tag in l) {
      tagMaps.add(tag.toJson());
    }
    return tagMaps;
  }

  String toJsonString() {
    List<Map> tagMaps = List();
    if (l == null) {
      return null;
    }

    for (Tag tag in l) {
      tagMaps.add(tag.toJson());
    }
    return json.encode(tagMaps);
  }
}
