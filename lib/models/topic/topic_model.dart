import 'dart:ui';
import 'package:csslib/parser.dart' as csslib;
import 'package:csslib/visitor.dart';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/topic/children_model/topic_tag.dart';

import '../../data/enum/topic_type.dart';
import '../../helpers/color_serializer.dart';
import 'children_model/origin_image.dart';

part 'topic_model.g.dart';

@JsonSerializable()
class TopicModel {
  final String? id;
  final String? slug;
  late TopicType? type;
  final String? name;
  final bool? isFeatured;
  final int? slideShowImagesCount;
  final List<TopicTag>? tags;
  final int? sortOrder;
  final String? style;
  @ColorSerializer()
  Color? bgColor;
  @ColorSerializer()
  Color? subTitleColor;
  @ColorSerializer()
  Color? recordTitleColor;
  @ColorSerializer()
  Color? dividerColor;

  @JsonKey(name: 'og_image')
  OriginImage? originImage;

  TopicModel(
      {this.id,
      this.slug,
      this.type,
      this.name,
      this.isFeatured,
      this.slideShowImagesCount,
      this.tags,
      this.sortOrder,
      this.style,
      this.originImage});

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    var model = _$TopicModelFromJson(json);
    Color bgColor = Colors.white;
    Color subTitleColor = Colors.white;
    Color recordTitleColor = Colors.black;
    Color dividerColor = Colors.grey;
    Map<String, int> tagOrderMap = {};
    if (json.containsKey('style') &&
        (json['type'] == 'group' || json['type'] == TopicType.portraitWall)) {
      String styleString = json['style'] as String;

      StyleSheet css = csslib.parse(styleString);

      for (int i = 0; i < css.topLevels.length; i++) {
        var item = css.topLevels[i];
        if (item is RuleSet) {
          SelectorGroup? selectorGroup = item.selectorGroup;
          if (selectorGroup != null) {
            List<Selector> selectors = selectorGroup.selectors;
            List<SimpleSelectorSequence> simpleSelectors =
                selectors[0].simpleSelectorSequences;
            SimpleSelector simpleSelector = simpleSelectors[0].simpleSelector;
            // find background color
            if (simpleSelector.name == 'groupList') {
              bgColor = _findColorInCss(item);
            } else if (simpleSelector.name == 'groupListBlock') {
              // find divider color
              dividerColor = _findColorInCss(item);
            } else if (simpleSelector.name == 'groupListBlockContainer') {
              //find subtitle and record title text color
              simpleSelector = simpleSelectors[1].simpleSelector;
              if (simpleSelector.name == 'h1' && simpleSelectors.length == 2) {
                subTitleColor = _findColorInCss(item);
                recordTitleColor = subTitleColor;
              } else if (simpleSelector.name.contains('tag')) {
                String tagId = simpleSelector.name.replaceAll('tag-', '');
                int tagOrder = _findOrderInCss(item);
                tagOrderMap.putIfAbsent(tagId, () => tagOrder);
              }
            } else if (simpleSelector.name == 'portraitWallList__block' &&
                simpleSelectors.length == 2) {
              //find portrait wall background color
              simpleSelector = simpleSelectors[1].simpleSelector;
              if (simpleSelector.name == 'color') {
                bgColor = _findColorInCss(item);
                recordTitleColor = bgColor.computeLuminance() >= 0.5
                    ? Colors.black
                    : Colors.white;
              }
            }
          }
        }
        model.bgColor = bgColor;
        model.dividerColor = dividerColor;
        model.recordTitleColor = recordTitleColor;
        model.subTitleColor = subTitleColor;
      }
    }
    if (model.slideShowImagesCount != 0) {
      model.type = TopicType.slideshow;
    }
    return model;
  }

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);

  static Color _findColorInCss(RuleSet ruleSet) {
    Declaration declaration =
        ruleSet.declarationGroup.declarations[0] as Declaration;
    Expressions expressions = declaration.expression as Expressions;
    HexColorTerm hexColorTerm = expressions.expressions[0] as HexColorTerm;
    String colorString = '0xff${hexColorTerm.text}';
    return Color(int.parse(colorString));
  }

  static int _findOrderInCss(RuleSet ruleSet) {
    Declaration declaration =
        ruleSet.declarationGroup.declarations[0] as Declaration;
    Expressions expressions = declaration.expression as Expressions;
    NumberTerm numberTerm = expressions.expressions[0] as NumberTerm;
    String orderString = numberTerm.text;
    return int.parse(orderString);
  }
}
