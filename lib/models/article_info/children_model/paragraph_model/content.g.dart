// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      data: json['data'] as String?,
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'data': instance.data,
      'aspectRatio': instance.aspectRatio,
      'description': instance.description,
    };
