// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['slug'] as String?,
      json['title'] as String?,
      json['publishedDate'] as String?,
      json['style'] as String?,
      json['isMember'] as bool?,
      json['isExternal'] as bool? ?? false,
      json['heroImage'] == null
          ? null
          : HeroImage.fromJson(json['heroImage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'publishedDate': instance.publishedDate,
      'style': instance.style,
      'isMember': instance.isMember,
      'isExternal': instance.isExternal,
      'heroImage': instance.heroImage,
    };
