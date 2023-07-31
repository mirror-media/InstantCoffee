import 'package:json_annotation/json_annotation.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  String? key;
  String? text;
  String? type;
  int? depth;

  Block({this.key, this.text, this.type, this.depth});

  factory Block.fromJson(Map<String, dynamic> json) =>
      _$BlockFromJson(json);

  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
