import 'package:flutter/material.dart';
import 'package:flutter_draft/flutter_draft.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/article_info/children_model/article_tag.dart';
import 'package:readr_app/data/enum/author_occupation.dart';

import 'package:readr_app/models/author_occupation.dart';
import 'package:readr_app/models/post/post_model.dart';

import '../../helpers/data_constants.dart';
import '../../helpers/environment.dart';
import '../story_ad.dart';
import 'children_model/brief/brief.dart';
import 'children_model/category.dart';
import 'children_model/hero_image/hero_image.dart';
import 'children_model/paragraph_model/paragraph.dart';
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
  @JsonKey(name: 'apiData')
  List<Paragraph>? paragraphList;
  List<Category>? categories;
  List<Section>? sections;
  Widget? content;
  Widget? trimmedContent;
  bool? isMember;
  bool? isAdvertised;
  StoryAd? storyAd;

  ArticleInfo({this.slug,
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
    this.paragraphList,
    this.categories,
    this.sections,
    this.isMember,
    this.isAdvertised,
    this.content
    ,
    this.trimmedContent});

  factory ArticleInfo.fromJson(Map<String, dynamic> json) =>
      ArticleInfo(
        content: DraftTextView(data: DraftData.fromJson(json['content'])),
        trimmedContent: DraftTextView(data: DraftData.fromJson(json['trimmedContent'])),
        slug: json['slug'] as String?,
        title: json['title'] as String?,
        publishedDate: json['publishedDate'] as String?,
        updatedAt: json['updatedAt'] as String?,
        heroVideo: json['heroVideo'] as String?,
        heroImage: json['heroImage'] == null
            ? null
            : HeroImage.fromJson(json['heroImage'] as Map<String, dynamic>),
        relatedArticles: (json['relateds'] as List<dynamic>?)
            ?.map((e) => PostModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        heroCaption: json['heroCaption'] as String?,
        extendByline: json['extendByline'] as String?,
        tags: (json['tags'] as List<dynamic>?)
            ?.map((e) => ArticleTag.fromJson(e as Map<String, dynamic>))
            .toList(),
        writers: (json['writers'] as List<dynamic>?)
            ?.map((e) => People.fromJson(e as Map<String, dynamic>))
            .toList(),
        photographers: (json['photographers'] as List<dynamic>?)
            ?.map((e) => People.fromJson(e as Map<String, dynamic>))
            .toList(),
        cameraMan: (json['cameraMan'] as List<dynamic>?)
            ?.map((e) => People.fromJson(e as Map<String, dynamic>))
            .toList(),
        designers: (json['designers'] as List<dynamic>?)
            ?.map((e) => People.fromJson(e as Map<String, dynamic>))
            .toList(),
        engineers: (json['engineers'] as List<dynamic>?)
            ?.map((e) => People.fromJson(e as Map<String, dynamic>))
            .toList(),
        brief: json['brief'] == null
            ? null
            : Brief.fromJson(json['brief'] as Map<String, dynamic>),
        paragraphList: (json['apiData'] as List<dynamic>?)
            ?.map((e) => Paragraph.fromJson(e as Map<String, dynamic>))
            .toList(),
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
        sections: (json['sections'] as List<dynamic>?)
            ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
            .toList(),
        isMember: json['isMember'] as bool?,
        isAdvertised: json['isAdvertised'] as bool?,
      )
        ..storyAd = json['storyAd'] == null
            ? null
            : StoryAd.fromJson(json['storyAd'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ArticleInfoToJson(this);

  String? get shareUrl =>
      slug != null
          ? '${Environment().config
          .mirrorMediaDomain}/story/$slug/?utm_source=app&utm_medium=mmapp'
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
