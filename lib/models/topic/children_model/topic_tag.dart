import 'package:json_annotation/json_annotation.dart';

part 'topic_tag.g.dart';

@JsonSerializable()
class TopicTag {
  String? id;

  TopicTag({this.id});

  factory TopicTag.fromJson(Map<String, dynamic> json) =>
      _$TopicTagFromJson(json);

  Map<String, dynamic> toJson() => _$TopicTagToJson(this);
}
