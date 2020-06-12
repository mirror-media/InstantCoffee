import 'dart:convert';

import 'Section.dart';

class SectionList {
  List<Section> sections = new List();

  SectionList({
    this.sections,
  });

  factory SectionList.fromJson(List<dynamic> parsedJson) {
     List<Section> sections = new List<Section>();

//print(parsedJson);
     sections = parsedJson.map((i) => Section.fromJson(i)).toList();

      return new SectionList(
        sections: sections,
      );
  }

  String toJson() {
    List<Map> sectionItems = new List();
    if (this.sections != null) {
      for (Section section in this.sections) {
        Map item = new Map();
        item["name"] = section.name;
        item["title"] = section.title;
        item["order"] = section.order;
        item["key"] = section.key;
        item["type"] = section.type;
        item["description"] = section.description;
        sectionItems.add(item);
      }
      return json.encode(sectionItems);
    } else {
      return "";
    }
    
  }

  void sortSections() {
    SectionList allSections = this;
    allSections.sections.sort((a,b) => a.order.compareTo(b.order));
    for (int i = 0; i < allSections.sections.length; i++) {
      allSections.sections[i].setOrder(i);
    }
    this.sections = allSections.sections;
  }

}