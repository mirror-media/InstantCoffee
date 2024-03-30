import 'package:get/get.dart';
import 'package:readr_app/data/enum/paragraph/paragraph_type.dart';
import 'package:readr_app/models/content.dart';

class Paragraph {
  String? styles;
  List<Content> contents;
  String? type;
  String? id;
  ParagraphType? paragraphType;

  Paragraph(
      {this.styles,
      required this.contents,
      this.type,
      this.id,
      this.paragraphType});

  factory Paragraph.fromJsonK6(Map<String, dynamic> json) {
    List<Content> contents = json["content"] == null
        ? []
        : Content.contentListFromJson(json["content"], json['type']);
    final result = ParagraphType.values.firstWhereOrNull((element) =>
    element.name.toLowerCase() ==
        json['type'].toLowerCase().replaceAll('-', '')) ??
        ParagraphType.unKnow;
    return Paragraph(
      contents: contents,
      type: json['type'],
      paragraphType: result,
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
