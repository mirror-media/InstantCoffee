import 'package:readr_app/models/content.dart';

class Paragraph {
  String? styles;
  List<Content> contents;
  String? type;
  String? id;

  Paragraph({this.styles, required this.contents, this.type, this.id});

  factory Paragraph.fromJsonK6(Map<String, dynamic> json) {
    List<Content> contents = json["content"] == null
        ? []
        : Content.contentListFromJson(json["content"], json['type']);

    return Paragraph(
      contents: contents,
      type: json['type'],
      id: json['id'],
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
