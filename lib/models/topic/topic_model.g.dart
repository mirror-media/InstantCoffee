// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) => TopicModel(
      id: json['id'] as String?,
      slug: json['slug'] as String?,
      type: $enumDecodeNullable(_$TopicTypeEnumMap, json['type']),
      name: json['name'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TopicTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      slideShowImagesCount: json['slideshow_imagesCount'] as int?,
      sortOrder: json['sortOrder'] as int?,
      style: json['style'] as String?,
      originImage: json['og_image'] == null
          ? null
          : OriginImage.fromJson(json['og_image'] as Map<String, dynamic>),
    )
      ..bgColor = _$JsonConverterFromJson<int, Color>(
          json['bgColor'], const ColorSerializer().fromJson)
      ..subTitleColor = _$JsonConverterFromJson<int, Color>(
          json['subTitleColor'], const ColorSerializer().fromJson)
      ..recordTitleColor = _$JsonConverterFromJson<int, Color>(
          json['recordTitleColor'], const ColorSerializer().fromJson)
      ..dividerColor = _$JsonConverterFromJson<int, Color>(
          json['dividerColor'], const ColorSerializer().fromJson);

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TopicTypeEnumMap[instance.type],
      'name': instance.name,
      'isFeatured': instance.isFeatured,
      'tags': instance.tags,
      'sortOrder': instance.sortOrder,
      'style': instance.style,
      'bgColor': _$JsonConverterToJson<int, Color>(
          instance.bgColor, const ColorSerializer().toJson),
      'subTitleColor': _$JsonConverterToJson<int, Color>(
          instance.subTitleColor, const ColorSerializer().toJson),
      'recordTitleColor': _$JsonConverterToJson<int, Color>(
          instance.recordTitleColor, const ColorSerializer().toJson),
      'dividerColor': _$JsonConverterToJson<int, Color>(
          instance.dividerColor, const ColorSerializer().toJson),
      'og_image': instance.originImage,
    };

const _$TopicTypeEnumMap = {
  TopicType.list: 'list',
  TopicType.group: 'group',
  TopicType.portraitWall: 'portrait wall',
  TopicType.slideshow: 'slideshow',
  TopicType.timeline: 'timeline',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
