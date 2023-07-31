// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleInfo _$ArticleInfoFromJson(Map<String, dynamic> json) => ArticleInfo(
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
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
      isMember: json['isMember'] as bool?,
      isAdvertised: json['isAdvertised'] as bool?,
    );

Map<String, dynamic> _$ArticleInfoToJson(ArticleInfo instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'publishedDate': instance.publishedDate,
      'updatedAt': instance.updatedAt,
      'heroVideo': instance.heroVideo,
      'heroImage': instance.heroImage,
      'relateds': instance.relatedArticles,
      'heroCaption': instance.heroCaption,
      'extendByline': instance.extendByline,
      'tags': instance.tags,
      'writers': instance.writers,
      'photographers': instance.photographers,
      'cameraMan': instance.cameraMan,
      'designers': instance.designers,
      'engineers': instance.engineers,
      'brief': instance.brief,
      'categories': instance.categories,
      'sections': instance.sections,
      'isMember': instance.isMember,
      'isAdvertised': instance.isAdvertised,
    };
