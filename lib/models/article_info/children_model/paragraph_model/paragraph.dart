import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/data/enum/paragraph/paragraph_type.dart';

import 'content.dart';

part 'paragraph.g.dart';

@JsonSerializable()
class Paragraph {
  Map<String, dynamic>? styles;
  List<Content>? contents;

  ParagraphType? type;
  String? id;

  Paragraph({
    this.id,
    this.styles,
    this.contents,
    this.type,
  });

  factory Paragraph.fromJson(Map<String, dynamic> json) =>
      _$ParagraphFromJson(json);

  Map<String, dynamic> toJson() => _$ParagraphToJson(this);
}
