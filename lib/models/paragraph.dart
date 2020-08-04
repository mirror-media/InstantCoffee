import 'package:readr_app/models/contentList.dart';

class Paragraph {
  String styles;
  ContentList contents;
  String type;

  Paragraph({
    this.styles,
    this.contents,
    this.type,
  });

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    ContentList contents;
    contents = ContentList.fromJson(json["content"]);
    
    return Paragraph(
      type: json['type'],
      contents: contents,
    );
  }
}
