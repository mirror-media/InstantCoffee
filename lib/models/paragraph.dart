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

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    List<Content> contents = json["content"] == null 
    ? []
    : Content.contentListFromJson(json["content"]);

    return Paragraph(
      contents: contents,
      type: json['type'],
    );
  }

  static List<Paragraph> paragraphListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Paragraph>((json) => Paragraph.fromJson(json)).toList();
  }
}
