import 'package:json_annotation/json_annotation.dart';

import '../../helpers/environment.dart';
import 'children_model/hero_image.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  PostModel(this.slug, this.title, this.publishedDate, this.style, this.isMember,
      this.isExternal, this.heroImage);

  String? slug;
  String? title;
  String? publishedDate;
  String? style;
  bool? isMember;
  @JsonKey(defaultValue: false)
  bool isExternal;
  HeroImage? heroImage;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  String? get getUrl =>
      style == 'projects' || style == 'campaign' ? '${Environment().config
          .mirrorMediaDomain}/$style/$slug' : null;



}