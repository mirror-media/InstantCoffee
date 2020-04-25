import 'Section.dart';

class SectionList {
  List<Section> sections = new List();

  SectionList({
    this.sections,
  });

  factory SectionList.fromJson(List<dynamic> parsedJson) {
     List<Section> sections = new List<Section>();

     sections = parsedJson.map((i) => Section.fromJson(i)).toList();

      return new SectionList(
        sections: sections,
      );
  }
}