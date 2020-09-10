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
    List<Map> sectionMaps = List();
    if (l == null) {
      return null;
    }

    for (Section section in l) {
      sectionMaps.add(section.toJson());
    }
    return sectionMaps;
  }

  String toJsonString() {
    List<Map> sectionMaps = List();
    if (l == null) {
      return null;
    }

    for (Section section in l) {
      sectionMaps.add(section.toJson());
    }
    return json.encode(sectionMaps);
  }

  void sortSections() {
    SectionList allSections = this;
    allSections.sort((a, b) => a.order.compareTo(b.order));
    for (int i = 0; i < allSections.length; i++) {
      allSections[i].setOrder(i);
    }
    l = allSections;
  }

  void deleteTheSectionByKey(String key) {
    for(int i=l.length-1; i>=0; i--) {
      if(l[i].key == key) {
        l.removeAt(i);
      }
    }
  }
}
