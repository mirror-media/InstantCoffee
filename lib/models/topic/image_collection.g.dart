// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageCollection _$ImageCollectionFromJson(Map<String, dynamic> json) =>
    ImageCollection(
      original: json['original'] as String?,
      w480: json['w480'] as String?,
      w800: json['w800'] as String?,
      w1200: json['w1200'] as String?,
      w1600: json['w1600'] as String?,
      w2400: json['w2400'] as String?,
    );

Map<String, dynamic> _$ImageCollectionToJson(ImageCollection instance) =>
    <String, dynamic>{
      'original': instance.original,
      'w480': instance.w480,
      'w800': instance.w800,
      'w1200': instance.w1200,
      'w1600': instance.w1600,
      'w2400': instance.w2400,
    };
