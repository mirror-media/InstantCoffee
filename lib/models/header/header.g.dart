// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Header _$HeaderFromJson(Map<String, dynamic> json) => Header(
      order: json['order'] as int?,
      type: $enumDecodeNullable(_$HeaderTypeEnumMap, json['type']),
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => HeaderCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      isMemberOnly: json['isMemberOnly'] as bool?,
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HeaderToJson(Header instance) => <String, dynamic>{
      'order': instance.order,
      'type': _$HeaderTypeEnumMap[instance.type],
      'slug': instance.slug,
      'name': instance.name,
      'categories': instance.categories,
      'isMemberOnly': instance.isMemberOnly,
      'sections': instance.sections,
    };

const _$HeaderTypeEnumMap = {
  HeaderType.section: 'section',
  HeaderType.category: 'category',
};
