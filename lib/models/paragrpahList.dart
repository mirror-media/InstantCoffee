import 'package:readr_app/models/paragraph.dart';

class ParagraphList {
  List<Paragraph> paragraphs = new List();

  ParagraphList({
    this.paragraphs,
  });

  factory ParagraphList.fromJson(List<dynamic> parsedJson) {
    List<Paragraph> paragraphs = new List<Paragraph>();

    if (parsedJson != null) {
      paragraphs = parsedJson.map((i) => Paragraph.fromJson(i)).toList();
    }

    return new ParagraphList(
      paragraphs: paragraphs,
    );
  }
}
