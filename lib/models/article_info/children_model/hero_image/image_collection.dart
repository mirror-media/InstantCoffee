


import 'package:json_annotation/json_annotation.dart';

part 'image_collection.g.dart';

@JsonSerializable()
class ImageCollection {
  String? original;
  String? w480;
  String? w800;
  String? w1200;
  String? w1600;
  String? w2400;

  ImageCollection(
      {this.original,
        this.w480,
        this.w800,
        this.w1200,
        this.w1600,
        this.w2400});

  factory ImageCollection.fromJson(Map<String, dynamic> json) =>
      _$ImageCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$ImageCollectionToJson(this);
}
