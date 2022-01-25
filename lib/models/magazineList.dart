import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/magazine.dart';

class MagazineList extends CustomizedList<Magazine> {
  int total = 0;
  // constructor
  MagazineList();

  factory MagazineList.fromJson(List<dynamic> parsedJson, String type) {
    MagazineList magazines = MagazineList();
    List parseList = parsedJson.map((i) => Magazine.fromJson(i, type)).toList();
    parseList.forEach((element) {
      magazines.add(element);
    });

    return magazines;
  }

  factory MagazineList.parseResponseBody(String body, String type) {
    final jsonData = json.decode(body);

    return MagazineList.fromJson(jsonData, type);
  }
}
