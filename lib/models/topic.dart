import 'package:flutter/material.dart';
import 'package:csslib/parser.dart' as csslib;
import 'package:csslib/visitor.dart';
import 'package:readr_app/helpers/environment.dart';

enum TopicType {
  list,
  group,
  portraitWall,
  slideshow,
}

class Topic {
  final String id;
  final String title;
  final bool isFeatured;
  final int sortOrder;
  final TopicType type;
  final String ogImageUrl;
  final Color bgColor;
  final List<String>? tagIdList;
  final Map<String, int>? tagOrderMap;
  final Color subTitleColor;
  final Color recordTitleColor;
  final Color dividerColor;

  Topic({
    required this.id,
    required this.title,
    this.isFeatured = false,
    this.sortOrder = 0,
    required this.type,
    required this.ogImageUrl,
    this.bgColor = Colors.white,
    this.tagIdList,
    this.subTitleColor = Colors.white,
    this.recordTitleColor = Colors.black,
    this.dividerColor = Colors.grey,
    this.tagOrderMap,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    String ogImageUrl = Environment().config.mirrorMediaNotImageUrl;
    if (json.containsKey('og_image')) {
      ogImageUrl = json['og_image']['image']['resizedTargets']['mobile']['url'];
    }

    TopicType type;
    if (json['type'] == 'group') {
      type = TopicType.group;
    } else if (json['type'] == 'portrait wall') {
      type = TopicType.portraitWall;
    } else if (json['leading'] == 'slideshow') {
      type = TopicType.slideshow;
    } else {
      type = TopicType.list;
    }

    Color bgColor = Colors.white;
    Color subTitleColor = Colors.white;
    Color recordTitleColor = Colors.black;
    Color dividerColor = Colors.grey;
    Map<String, int> tagOrderMap = {};
    if (json.containsKey('style') &&
        (type == TopicType.group || type == TopicType.portraitWall)) {
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
      }
    }

    List<String>? tagIdList;
    if (json.containsKey('tags') &&
        type == TopicType.group &&
        json['tags'].isNotEmpty) {
      tagIdList = [];
      for (var tagId in json['tags']) {
        tagIdList.add(tagId);
      }
    }

    return Topic(
      id: json['_id'],
      title: json['name'],
      isFeatured: json['isFeatured'],
      sortOrder: json['sortOrder'],
      ogImageUrl: ogImageUrl,
      type: type,
      bgColor: bgColor,
      tagIdList: tagIdList,
      subTitleColor: subTitleColor,
      recordTitleColor: recordTitleColor,
      dividerColor: dividerColor,
      tagOrderMap: tagOrderMap,
    );
  }

  static Color _findColorInCss(RuleSet ruleSet) {
    Declaration declaration =
        ruleSet.declarationGroup.declarations[0] as Declaration;
    Expressions expressions = declaration.expression as Expressions;
    HexColorTerm hexColorTerm = expressions.expressions[0] as HexColorTerm;
    String colorString = '0xff' + hexColorTerm.text;
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
