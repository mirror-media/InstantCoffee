

import 'package:json_annotation/json_annotation.dart';

part 'people.g.dart';

@JsonSerializable()
class People {
  String id;
  String name;

  People({
    required this.id,
    required this.name,
  });

  factory People.fromJson(Map<String, dynamic> json) =>
      _$PeopleFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleToJson(this);
}