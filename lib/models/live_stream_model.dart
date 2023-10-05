import 'package:json_annotation/json_annotation.dart';

part 'live_stream_model.g.dart';

@JsonSerializable()
class LiveStreamModel {
  final String? name;
  final String? link;
  final String? startDate;
  final String? endDate;

  LiveStreamModel({this.name, this.link,this.endDate,this.startDate});

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveStreamModelToJson(this);
}
