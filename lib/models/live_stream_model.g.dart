// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_stream_model.dart';
// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************



LiveStreamModel _$LiveStreamModelFromJson(Map<String, dynamic> json) =>
    LiveStreamModel(
      name: json['name'] as String?,
      link: json['link'] as String?,
      endDate: json['endDate'] as String?,
      startDate: json['startDate'] as String?,

    );

Map<String, dynamic> _$LiveStreamModelToJson(LiveStreamModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'link': instance.link,
      'endDate':instance.endDate,
      'startDate':instance.startDate,
    };