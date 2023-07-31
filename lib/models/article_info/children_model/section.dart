import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';
@JsonSerializable()
class Section {
  String? name;
  String? slug;
  String? description;

  Section({this.name, this.slug, this.description});
  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);

}