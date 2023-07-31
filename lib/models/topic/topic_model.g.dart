// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) => TopicModel(
      id: json['id'] as String?,
      subTitleColor: json['subTitleColor'] ?? Colors.white,
      recordTitleColor: json['recordTitleColor'] ?? Colors.black,
      dividerColor: json['dividerColor'] ?? Colors.grey,
      bgColor: json['bgColor'] ?? Colors.white,
      type: $enumDecodeNullable(_$TopicTypeEnumMap, json['type']),
      name: json['name'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TopicTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: json['sortOrder'] as int?,
      style: json['style'] as String?,
      originImage: json['og_image'] == null
          ? null
          : OriginImage.fromJson(json['og_image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TopicTypeEnumMap[instance.type],
      'name': instance.name,
      'isFeatured': instance.isFeatured,
      'tags': instance.tags,
      'sortOrder': instance.sortOrder,
      'style': instance.style,
      'bgColor': instance.bgColor,
      'subTitleColor': instance.subTitleColor,
      'recordTitleColor': instance.recordTitleColor,
      'dividerColor': instance.dividerColor,
      'og_image': instance.originImage,
    };

const _$TopicTypeEnumMap = {
  TopicType.list: 'list',
  TopicType.group: 'group',
  TopicType.portraitWall: 'portrait wall',
  TopicType.slideshow: 'slideshow',
  TopicType.timeline: 'timeline',
};
