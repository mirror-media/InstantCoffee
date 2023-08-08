import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/data/enum/paragraph/paragraph_type.dart';
import 'package:readr_app/models/article_info/children_model/hero_image/image_collection.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
  String? data;
  double? aspectRatio;
  String? description;
  String? imageUrl;
  int? slideShowDelay;
  List<ImageCollection>? slideShowImageList;
  List<String>? itemList;

  Content(
      {this.data,
      this.aspectRatio,
      this.description,
      this.imageUrl,
      this.slideShowDelay,
      this.slideShowImageList,
      this.itemList});

  factory Content.fromJson(dynamic jsonMap, ParagraphType? type) {
    if (jsonMap is Map<String, dynamic>) {
      Content content = _$ContentFromJson(jsonMap);
      if (jsonMap.containsKey('mobile') && jsonMap['mobile'] != null) {
        content.data = jsonMap['mobile']['url'];
        content.aspectRatio =
            jsonMap['mobile']['width'] / jsonMap['mobile']['height'];
        content.description = jsonMap['description'];
      } else if (jsonMap['youtubeId'] != null) {
        content.data = jsonMap['youtubeId'];
        content.aspectRatio = null;
        content.description = jsonMap['description'];
      } else if (jsonMap['filetype'] != null) {
        content.data = jsonMap['url'];
        content.aspectRatio = null;
        content.description = jsonMap['title'] + ';' + jsonMap['description'];
      }

      switch (type) {
        case ParagraphType.image:
          content.data = jsonMap['url'];
          content.description = jsonMap['description'];
          if (jsonMap.containsKey('mobile') && jsonMap['mobile'] != null) {
            content.aspectRatio =
                jsonMap['mobile']['width'] / jsonMap['mobile']['height'];
          }
          break;
        case ParagraphType.infoBox:
          content.data = jsonMap['title'];
          content.description = jsonMap['body'];
          break;
        case ParagraphType.annotation:
        case ParagraphType.headerOne:
        case ParagraphType.headerTwo:
        case ParagraphType.codeBlock:
        case ParagraphType.unStyled:
          content.data = jsonMap.toString();
          break;
        case ParagraphType.orderedListItem:
        case ParagraphType.unorderedListItem:
          content.itemList = (json.decode(jsonMap.toString()) as List<dynamic>)
              .map((item) => item.toString())
              .toList();
          break;
        case ParagraphType.slideShowV2:
        case ParagraphType.slideShow:
          content.slideShowDelay = jsonMap['delay'];
          final imagesList = jsonMap['images'] as List<dynamic>;
          content.slideShowImageList = [];

          content.slideShowImageList?.addAll(imagesList.map((image) {
            return ImageCollection.fromJson(image['resized']);
          }).toList());

          break;
        case ParagraphType.youtube:
          content.data = jsonMap['youtubeId'];
          content.aspectRatio = null;
          content.description = jsonMap['description'];
          break;
        case ParagraphType.video:
          content.data = jsonMap['video']['urlOriginal'];
          content.description = jsonMap['video']['name'];
          break;
        case ParagraphType.audio:
          content.data = jsonMap['audio']['urlOriginal'];
          content.description = jsonMap['audio']['name'];
          break;
        case ParagraphType.embeddedCode:
          double? aspectRatio;
          if (jsonMap['width'] != null &&
              jsonMap['height'] != null &&
              jsonMap['width'] is String &&
              jsonMap['height'] is String) {
            aspectRatio = double.parse(jsonMap['width']) /
                double.parse(jsonMap['height']);
          }
          content.data = jsonMap['embeddedCode'];
          content.aspectRatio = aspectRatio;
          content.description = jsonMap['caption'];
          break;
        case ParagraphType.blockQuote:
        case ParagraphType.quoteBy:
          content.data = jsonMap['quote'];
          content.aspectRatio = null;
          content.description = jsonMap['quoteBy'];
          break;
        case ParagraphType.unKnow:
          // TODO: Handle this case.
          break;
      }
      return content;
    }
    return Content(
      data: jsonMap.toString(),
      aspectRatio: null,
      description: null,
    );
  }

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
