// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'origin_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OriginImage _$OriginImageFromJson(Map<String, dynamic> json) => OriginImage(
      imageCollection: json['resized'] == null
          ? null
          : ImageCollection.fromJson(json['resized'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OriginImageToJson(OriginImage instance) =>
    <String, dynamic>{
      'resized': instance.imageCollection,
    };
