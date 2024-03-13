import 'package:json_annotation/json_annotation.dart';

enum HeaderType {
  @JsonValue('section')
  section,
  @JsonValue('category')
  category
}
