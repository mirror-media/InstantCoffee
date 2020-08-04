import 'dart:convert';

import 'package:readr_app/models/content.dart';
import 'package:readr_app/models/customizedList.dart';

class ContentList extends CustomizedList<Content> {
  // constructor
  ContentList();

  factory ContentList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    ContentList contents = ContentList();

    List parseList = List();
    for(int i=0; i<parsedJson.length; i++) {
      parseList.add(Content.fromJson(parsedJson[i]));
    }
    
    parseList.forEach((element) {
      contents.add(element);
    });

    return contents;
  }

  factory ContentList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return ContentList.fromJson(jsonData);
  }
}
