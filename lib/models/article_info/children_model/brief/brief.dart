import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/article_info/children_model/brief/block.dart';

part 'brief.g.dart';

@JsonSerializable()
class Brief {
  List<Block>? blocks;

  Brief({
    this.blocks,
  });

  factory Brief.fromJson(Map<String, dynamic> json) => _$BriefFromJson(json);

  Map<String, dynamic> toJson() => _$BriefToJson(this);
}
