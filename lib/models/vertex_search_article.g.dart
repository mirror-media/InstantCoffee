// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertex_search_article.dart';

VertexSearchArticle _$VertexSearchArticleFromJson(Map<String, dynamic> json) =>
    VertexSearchArticle(
      json['name'] as String? ?? '',
      json['id'] as String? ?? '',
      json['structData'] == null
          ? StructData()
          : StructData.fromJson(json['structData'] as Map<String, dynamic>),
      json['derivedStructData'] == null
          ? DerivedStructData()
          : DerivedStructData.fromJson(
              json['derivedStructData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VertexSearchArticleToJson(
        VertexSearchArticle instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'structData': instance.structData?.toJson(),
      'derivedStructData': instance.derivedStructData?.toJson(),
    };

StructData _$StructDataFromJson(Map<String, dynamic> json) => StructData(
      pageType: (json['page-type'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      sectionName: (json['section-name'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      datePublished: (json['datePublished'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      author: (json['author'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      pageImage: (json['page-image'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dateModified: (json['dateModified'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      sectionSlug: (json['section-slug'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      articleDescription: (json['article-description'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      pageSlug: (json['page-slug'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$StructDataToJson(StructData instance) =>
    <String, dynamic>{
      'page-type': instance.pageType,
      'section-name': instance.sectionName,
      'datePublished': instance.datePublished,
      'author': instance.author,
      'page-image': instance.pageImage,
      'dateModified': instance.dateModified,
      'section-slug': instance.sectionSlug,
      'article-description': instance.articleDescription,
      'page-slug': instance.pageSlug,
    };

DerivedStructData _$DerivedStructDataFromJson(Map<String, dynamic> json) =>
    DerivedStructData(
      title: json['title'] as String? ?? '',
      link: json['link'] as String? ?? '',
      displayLink: json['displayLink'] as String? ?? '',
      htmlTitle: json['htmlTitle'] as String? ?? '',
    );

Map<String, dynamic> _$DerivedStructDataToJson(DerivedStructData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'link': instance.link,
      'displayLink': instance.displayLink,
      'htmlTitle': instance.htmlTitle,
    };
