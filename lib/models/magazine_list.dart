import 'dart:convert';

import 'package:readr_app/models/customized_list.dart';
import 'package:readr_app/models/magazine.dart';

class MagazineList extends CustomizedList<Magazine> {
  int total = 0;

  // constructor
  MagazineList();

  factory MagazineList.fromJson(List<dynamic> parsedJson, String type,
      {bool isK6 = false}) {
    MagazineList magazines = MagazineList();
    List parseList = parsedJson
        .map((i) =>
            isK6 ? Magazine.fromJsonK6(i, type) : Magazine.fromJson(i, type))
        .toList();
    for (var element in parseList) {
      magazines.l.add(element);
    }

    return magazines;
  }

  factory MagazineList.parseResponseBody(String body, String type) {
    final jsonData = json.decode(body);

    return MagazineList.fromJson(jsonData, type);
  }
}
