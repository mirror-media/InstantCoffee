import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/article_info/children_model/article_tag.dart';

import 'package:readr_app/models/post/post_model.dart';

import '../../helpers/environment.dart';
import '../story_ad.dart';
import 'children_model/brief.dart';
import 'children_model/category.dart';
import 'children_model/hero_image.dart';
import 'children_model/people.dart';
import 'children_model/section.dart';

part 'article_info.g.dart';

@JsonSerializable()
class ArticleInfo {
  String? slug;
  String? title;
  String? publishedDate;
  String? updatedAt;
  String? heroVideo;
  HeroImage? heroImage;
  @JsonKey(name: 'relateds')
  List<PostModel>? relatedArticles;
  String? heroCaption;
  String? extendByline;
  List<ArticleTag>? tags;
  List<People>? writers;
  List<People>? photographers;
  List<People>? cameraMan;
  List<People>? designers;
  List<People>? engineers;
  Brief? brief;
  List<Category>? categories;
  List<Section>? sections;
  bool? isMember;
  bool? isAdvertised;
  StoryAd? storyAd;

  ArticleInfo(
      {this.slug,
      this.title,
      this.publishedDate,
      this.updatedAt,
      this.heroVideo,
      this.heroImage,
      this.relatedArticles,
      this.heroCaption,
      this.extendByline,
      this.tags,
      this.writers,
      this.photographers,
      this.cameraMan,
      this.designers,
      this.engineers,
      this.brief,
      this.categories,
      this.sections,
      this.isMember,
      this.isAdvertised});

  factory ArticleInfo.fromJson(Map<String, dynamic> json) =>
      _$ArticleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleInfoToJson(this);

  String? get shareUrl => slug != null
      ? '${Environment().config.mirrorMediaDomain}/story/$slug/?utm_source=app&utm_medium=mmapp'
      : null;
}
