// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brief.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brief _$BriefFromJson(Map<String, dynamic> json) => Brief(
      blocks: (json['blocks'] as List<dynamic>?)
          ?.map((e) => Block.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BriefToJson(Brief instance) => <String, dynamic>{
      'blocks': instance.blocks,
    };
