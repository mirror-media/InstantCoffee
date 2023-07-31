import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';
@JsonSerializable()
class Category {
  String? id;
  String? name;
  String? slug;
  bool? isMemberOnly;
  Category({this.id, this.name, this.slug, this.isMemberOnly});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

}