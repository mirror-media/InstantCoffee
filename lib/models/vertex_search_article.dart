import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/helpers/environment.dart';

part 'vertex_search_article.g.dart';

@JsonSerializable()
class VertexSearchArticle extends Object {
  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'structData')
  StructData? structData;

  @JsonKey(name: 'derivedStructData')
  DerivedStructData? derivedStructData;

  String? get title => derivedStructData?.title;

  String? get slug {
    final slugList = structData?.pageSlug;
    return slugList == null || slugList.isEmpty ? null : slugList[0];
  }

  String get heroImagePath {
    final pageImageList = structData?.pageImage;

    return pageImageList == null || pageImageList.isEmpty
        ? Environment().config.mirrorMediaNotImageUrl
        : pageImageList[0];
  }

  VertexSearchArticle(
    this.name,
    this.id,
    this.structData,
    this.derivedStructData,
  );

  factory VertexSearchArticle.fromJson(Map<String, dynamic> srcJson) =>
      _$VertexSearchArticleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VertexSearchArticleToJson(this);
}

@JsonSerializable()
class StructData extends Object {
  @JsonKey(name: 'page-type', defaultValue: [])
  List<String>? pageType;

  @JsonKey(name: 'section-name', defaultValue: [])
  List<String>? sectionName;

  @JsonKey(name: 'datePublished', defaultValue: [])
  List<String>? datePublished;

  @JsonKey(name: 'author', defaultValue: [])
  List<String>? author;

  @JsonKey(name: 'page-image', defaultValue: [])
  List<String>? pageImage;

  @JsonKey(name: 'dateModified', defaultValue: [])
  List<String>? dateModified;

  @JsonKey(name: 'section-slug', defaultValue: [])
  List<String>? sectionSlug;

  @JsonKey(name: 'article-description', defaultValue: [])
  List<String>? articleDescription;

  @JsonKey(name: 'page-slug', defaultValue: [])
  List<String>? pageSlug;

  StructData({
    this.pageType,
    this.sectionName,
    this.datePublished,
    this.author,
    this.pageImage,
    this.dateModified,
    this.sectionSlug,
    this.articleDescription,
    this.pageSlug,
  });

  factory StructData.fromJson(Map<String, dynamic> srcJson) =>
      _$StructDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StructDataToJson(this);
}

@JsonSerializable()
class DerivedStructData extends Object {
  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'link')
  String? link;

  @JsonKey(name: 'displayLink')
  String? displayLink;

  @JsonKey(name: 'htmlTitle')
  String? htmlTitle;

  DerivedStructData({
    this.title,
    this.link,
    this.displayLink,
    this.htmlTitle,
  });

  factory DerivedStructData.fromJson(Map<String, dynamic> srcJson) =>
      _$DerivedStructDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DerivedStructDataToJson(this);
}
