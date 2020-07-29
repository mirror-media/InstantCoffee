import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/paragraph.dart';

class ParagraphList extends CustomizedList<Paragraph> {
  // constructor
  ParagraphList();

  factory ParagraphList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    ParagraphList objects = ParagraphList();
    List parseList = parsedJson.map((i) => Paragraph.fromJson(i)).toList();
    parseList.forEach((element) {
      objects.add(element);
    });

    return objects;
  }

  factory ParagraphList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return ParagraphList.fromJson(jsonData);
  }
}
