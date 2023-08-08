// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeroImage _$HeroImageFromJson(Map<String, dynamic> json) => HeroImage(
      id: json['id'] as String?,
      imageCollection: json['resized'] == null
          ? null
          : ImageCollection.fromJson(json['resized'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HeroImageToJson(HeroImage instance) => <String, dynamic>{
      'id': instance.id,
      'resized': instance.imageCollection,
    };
