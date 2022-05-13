import 'package:flutter/material.dart';

enum TopicType {
  list,
  group,
  portraitWall,
}

class Topic {
  final String id;
  final String title;
  final bool isFeatured;
  final int sortOrder;
  final TopicType type;
  final String? ogImageUrl;
  final Color bgColor;
  final List<String>? tagIdList;

  const Topic({
    required this.id,
    required this.title,
    this.isFeatured = false,
    this.sortOrder = 0,
    required this.type,
    this.ogImageUrl,
    this.bgColor = Colors.white,
    this.tagIdList,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    String? ogImageUrl;
    if (json.containsKey('og_image')) {
      ogImageUrl = json['og_image']['image']['resizedTargets']['mobile']['url'];
    }

    TopicType type;
    if (json['type'] == 'group') {
      type = TopicType.group;
    } else if (json['type'] == 'portrait wall') {
      type = TopicType.portraitWall;
    } else {
      type = TopicType.list;
    }

    Color bgColor = Colors.white;
    if (json.containsKey('style') && type != TopicType.list) {
      String styleString = json['style'] as String;
      if (styleString.contains('文章區塊背景色')) {
        //find background color text and convert to color
        const start = "文章區塊背景色 */\r\n  background-color:";
        const end = "!";
        final startIndex = styleString.indexOf(start);
        final endIndex = styleString.indexOf(end, startIndex + start.length);
        String hexString =
            styleString.substring(startIndex + start.length, endIndex);
        String colorString = hexString.replaceAll('#', '0xff');
        bgColor = Color(int.parse(colorString));
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
    );
  }
}
