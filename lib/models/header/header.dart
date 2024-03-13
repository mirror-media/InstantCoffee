import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/data/enum/header_type.dart';
import 'package:readr_app/models/header/header_category.dart';

part 'header.g.dart';

@JsonSerializable()
class Header {
  int? order;
  HeaderType? type;
  String? slug;
  String? name;
  List<HeaderCategory>? categories;
  bool? isMemberOnly;
  List<String>? sections;

  Header(
      {this.order,
      this.type,
      this.slug,
      this.name,
      this.categories,
      this.isMemberOnly,
      this.sections});

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderToJson(this);
}
