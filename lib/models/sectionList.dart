import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/section.dart';

class SectionList extends CustomizedList<Section> {
  // constructor
  SectionList();

  factory SectionList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    SectionList objects = SectionList();
    List parseList = parsedJson.map((i) => Section.fromJson(i)).toList();
    parseList.forEach((element) {
      objects.add(element);
    });

    return objects;
  }

  factory SectionList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return SectionList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (Section object in l) {
      objects.add(object.toJson());
    }
    return objects;
  }

  String toJsonString() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (Section object in l) {
      objects.add(object.toJson());
    }
    return json.encode(objects);
  }

  void sortSections() {
    SectionList allSections = this;
    allSections.sort((a, b) => a.order.compareTo(b.order));
    for (int i = 0; i < allSections.length; i++) {
      allSections[i].setOrder(i);
    }
    l = allSections;
  }
}
