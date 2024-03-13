// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaderCategory _$HeaderCategoryFromJson(Map<String, dynamic> json) =>
    HeaderCategory(
      id: json['id'] as String?,
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      isMemberOnly: json['isMemberOnly'] as bool?,
    );

Map<String, dynamic> _$HeaderCategoryToJson(HeaderCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'isMemberOnly': instance.isMemberOnly,
    };
