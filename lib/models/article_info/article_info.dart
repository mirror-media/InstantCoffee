
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/article_info/children_model/article_tag.dart';
import 'package:readr_app/data/enum/author_occupation.dart';
import 'package:readr_app/models/article_info/children_model/brief/brief.dart';
import 'package:readr_app/models/author_occupation.dart';
import 'package:readr_app/models/paragraph.dart';



import 'package:readr_app/models/post/post_model.dart';

import '../../helpers/data_constants.dart';
import '../../helpers/environment.dart';
import '../story_ad.dart';
import 'children_model/category.dart';
import 'children_model/hero_image/hero_image.dart';
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
  List<Paragraph>? brief;
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

  Color? get sectionColor {
    if (sectionName != null && sectionColorMaps.containsKey(sectionName)) {
      return Color(sectionColorMaps[sectionName]!);
    }
    return null;
  }

  String? get sectionName {
    if (sections != null) {
      if (sections!.contains('member')) {
        return 'member';
      }

      if (sections!.isNotEmpty) {
        return sections![0].name;
      }
    }
    return null;
  }

  List<AuthorOccupationModel> get authorList {
    List<AuthorOccupationModel> authorList = [];
    addPeopleListToAuthorList(authorList, writers, AuthorOccupation.writer);
    addPeopleListToAuthorList(
        authorList, photographers, AuthorOccupation.photographer);
    addPeopleListToAuthorList(
        authorList, cameraMan, AuthorOccupation.cameraMan);
    addPeopleListToAuthorList(authorList, designers, AuthorOccupation.designer);
    addPeopleListToAuthorList(authorList, engineers, AuthorOccupation.engineer);
    if (extendByline != null) {
      authorList
          .add(AuthorOccupationModel(AuthorOccupation.writer, extendByline!));
    }
    return authorList;
  }

  List<String> get categoryDisplayList {
    List<String> categoryDisplayList = [];

    if (sections != null && sections!.contains('member')) {
      categoryDisplayList.add('會員專區');
    }
    for (var section in sections!) {
      if (section.name != null) {
        categoryDisplayList.add(section.name!);
      }
    }

    for (var category in categories!) {
      if (category.name != null) {
        categoryDisplayList.add(category.name!);
      }
    }
    return categoryDisplayList;
  }

  void addPeopleListToAuthorList(List<AuthorOccupationModel> authorList,
      List<People>? peopleList, AuthorOccupation authorOccupation) {
    if (peopleList != null && peopleList.isNotEmpty) {
      authorList.addAll(peopleList
          .map((people) => AuthorOccupationModel(authorOccupation, people.name))
          .toList());
    }
  }
}
