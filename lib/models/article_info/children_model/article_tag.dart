import 'package:json_annotation/json_annotation.dart';

part 'article_tag.g.dart';

@JsonSerializable()
class ArticleTag{
  String? id;
  String? name;

  ArticleTag({this.id});

  factory ArticleTag.fromJson(Map<String, dynamic> json) =>
      _$ArticleTagFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleTagToJson(this);
}
