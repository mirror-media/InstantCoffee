// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block()
  ..data = json['data'] as Map<String, dynamic>?
  ..aspectRatio = (json['aspectRatio'] as num?)?.toDouble()
  ..description = json['description'] as String?
  ..type = json['type'] as String?;

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'data': instance.data,
      'aspectRatio': instance.aspectRatio,
      'description': instance.description,
      'type': instance.type,
    };
