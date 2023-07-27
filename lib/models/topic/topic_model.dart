import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/topic/topic_tag.dart';

import 'origin_image.dart';

part 'topic_model.g.dart';
@JsonSerializable()
class TopicModel {
  String? id;
  String? type;
  String? name;
  bool? isFeatured;
  List<TopicTag>? tags;
  int? sortOrder;

  @JsonKey(name: 'og_image')
  OriginImage? originImage;

  TopicModel(
      {this.id,
        this.type,
        this.name,
        this.isFeatured,
        this.tags,
        this.sortOrder,
        this.originImage});
  factory TopicModel.fromJson(Map<String, dynamic> json) => _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);

}