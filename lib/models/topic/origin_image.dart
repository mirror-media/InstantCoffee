
import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/post/image_collection.dart';

part 'origin_image.g.dart';
@JsonSerializable()
class OriginImage {

  @JsonKey(name: 'resized')
  ImageCollection? imageCollection;

  OriginImage({this.imageCollection});

  factory OriginImage.fromJson(Map<String, dynamic> json) => _$OriginImageFromJson(json);

  Map<String, dynamic> toJson() => _$OriginImageToJson(this);
}