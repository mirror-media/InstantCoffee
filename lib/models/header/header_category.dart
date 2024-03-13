import 'package:json_annotation/json_annotation.dart';

part 'header_category.g.dart';

@JsonSerializable()
class HeaderCategory {
  String? id;
  String? slug;
  String? name;
  bool? isMemberOnly;

  HeaderCategory({this.id, this.slug, this.name, this.isMemberOnly});

  factory HeaderCategory.fromJson(Map<String, dynamic> json) =>
      _$HeaderCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderCategoryToJson(this);
}
