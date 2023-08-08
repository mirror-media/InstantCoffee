import 'package:json_annotation/json_annotation.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  Map<String, dynamic>? data;
  double? aspectRatio;
  String? description;
  String? type;

  Block();

  factory Block.fromJson(Map<String, dynamic> json) {
    Block block = _$BlockFromJson(json);
    if (json.containsKey('mobile') && json['mobile'] != null) {
      block.data = json['mobile']['url'];
      block.aspectRatio = json['mobile']['width'] / json['mobile']['height'];
      block.description = json['description'];
    } else if (json['youtubeId'] != null) {
      block.data = json['youtubeId'];
      block.aspectRatio = null;
      block.description = json['description'];
    } else if (json['filetype'] != null) {
      block.data = json['url'];
      block.aspectRatio = null;
      block.description = json['title'] + ';' + json['description'];
    } else if (json['embeddedCode'] != null) {
      double? aspectRatio;

      if (json['width'] != null &&
          json['height'] != null &&
          json['width'] is String &&
          json['height'] is String) {
        aspectRatio =
            double.parse(json['width']) / double.parse(json['height']);
      }
      block.data = json['embeddedCode'];
      block.aspectRatio = aspectRatio;
      block.description = json['caption'];
    } else if (json['draftRawObj'] != null) {
      block.data = json['body'];
      block.aspectRatio = null;
      block.description = json['title'];
    } else if (json['quote'] != null) {
      block.data = json['quote'];
      block.aspectRatio = null;
      block.description = json['quoteBy'];
    }
    block.data = json;
    block.aspectRatio = null;
    block.description = null;
    if (json.containsKey('type')) {
      block.type = json['type'];
    }

    return block;
  }

  Map<String, dynamic> toJson() => _$BlockToJson(this);
}
