import 'dart:convert';

import 'package:readr_app/models/CustomizedList.dart';
import 'package:readr_app/models/Section.dart';

class SectionList extends CustomizedList<Section> {
  // constructor
  SectionList();

  factory SectionList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    SectionList sections = SectionList();
    List parseList = parsedJson.map((i) => Section.fromJson(i)).toList();
    parseList.forEach((element) {
      sections.add(element);
    });

    return sections;
  }

  factory SectionList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return SectionList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> sectionItems = new List();
    if (l == null) {
      return null;
    }

    for (Section section in l) {
      sectionItems.add(section.toJson());
    }
    return sectionItems;
  }

  String toJsonString() {
    List<Map> sectionItems = new List();
    if (l == null) {
      return null;
    }

    for (Section section in l) {
      sectionItems.add(section.toJson());
    }
    return json.encode(sectionItems);
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
