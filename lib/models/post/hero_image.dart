import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/post/image_collection.dart';

part 'hero_image.g.dart';
@JsonSerializable()
class HeroImage {
  String? id;
  @JsonKey(name: 'resized')
  ImageCollection? imageCollection;

  HeroImage({this.id, this.imageCollection});

  factory HeroImage.fromJson(Map<String, dynamic> json) =>
      _$HeroImageFromJson(json);

  Map<String, dynamic> toJson() => _$HeroImageToJson(this);
}
