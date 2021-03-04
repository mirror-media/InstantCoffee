import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/magazine.dart';

class MagazineList extends CustomizedList<Magazine> {
  // constructor
  MagazineList();

  factory MagazineList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    MagazineList magazines = MagazineList();
    List parseList = parsedJson.map((i) => Magazine.fromJson(i)).toList();
    parseList.forEach((element) {
      magazines.add(element);
    });

    return magazines;
  }

  factory MagazineList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return MagazineList.fromJson(jsonData);
  }
}
