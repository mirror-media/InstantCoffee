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
    for (final i in parsedJson) {
      if (i == null) continue;
      final Magazine magazine =
          isK6 ? Magazine.fromJsonK6(i, type) : Magazine.fromJson(i, type);
      magazines.l.add(magazine);
    }

    return magazines;
  }

  factory MagazineList.parseResponseBody(String body, String type) {
    final jsonData = json.decode(body);

    return MagazineList.fromJson(jsonData, type);
  }
}
