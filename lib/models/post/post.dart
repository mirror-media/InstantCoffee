import 'package:json_annotation/json_annotation.dart';

import 'hero_image.dart';
part 'post.g.dart';

@JsonSerializable()
class Post {
  Post(this.slug, this.title,this.publishedDate,this.style,this.heroImage);

  String? slug;
  String? title;
  String? publishedDate;
  String? style;
  HeroImage? heroImage;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}