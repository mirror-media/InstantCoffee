// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) => TopicModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TopicTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: json['sortOrder'] as int?,
      originImage: json['og_image'] == null
          ? null
          : OriginImage.fromJson(json['og_image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'isFeatured': instance.isFeatured,
      'tags': instance.tags,
      'sortOrder': instance.sortOrder,
      'og_image': instance.originImage,
    };
