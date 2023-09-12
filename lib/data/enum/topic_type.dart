import 'package:json_annotation/json_annotation.dart';

enum TopicType {

  @JsonValue('list')
  list,
  @JsonValue('group')
  group,
  @JsonValue('portrait wall')
  portraitWall,
  @JsonValue('slideshow')
  slideshow,
  @JsonValue('timeline')
  timeline,
}