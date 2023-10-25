import 'package:readr_app/models/content.dart';

class Paragraph {
  String? styles;
  List<Content> contents;
  String? type;

  Paragraph({
    this.styles,
    required this.contents,
    this.type,
  });
  ///為了避免相依性導致其他元件的Bug,因此將infobox獨立出來修改,後續3.0建議都用type作為資料的判讀
  factory Paragraph.fromJsonK6(Map<String, dynamic> json) {
    List<Content> contents = json["content"] == null
        ? []
        : Content.contentListFromJson(json["content"], json['type']);

    return Paragraph(
      contents: contents,
      type: json['type'],
    );
  }

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    List<Content> contents = json["content"] == null
        ? []
        : Content.contentListFromJson(json["content"], json['type']);

    return Paragraph(
      contents: contents,
      type: json['type'],
    );
  }

  static List<Paragraph> paragraphListFromJson(List<dynamic> jsonList) {
    List<Paragraph> paragraphList =
        jsonList.map<Paragraph>((json) => Paragraph.fromJsonK6(json)).toList();
    paragraphList.removeWhere((paragraph) => paragraph.contents.isEmpty);
    return paragraphList;
  }
}
