// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      key: json['key'] as String?,
      text: json['text'] as String?,
      type: json['type'] as String?,
      depth: json['depth'] as int?,
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'key': instance.key,
      'text': instance.text,
      'type': instance.type,
      'depth': instance.depth,
    };
