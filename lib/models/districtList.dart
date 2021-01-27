import 'dart:convert';

import 'package:readr_app/models/district.dart';
import 'package:readr_app/models/customizedList.dart';

class DistrictList extends CustomizedList<District> {
  // constructor
  DistrictList();

  factory DistrictList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    DistrictList contents = DistrictList();

    List parseList = List();
    for (int i = 0; i < parsedJson.length; i++) {
      parseList.add(District.fromJson(parsedJson[i]));
    }

    parseList.forEach((element) {
      contents.add(element);
    });

    return contents;
  }

  factory DistrictList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return DistrictList.fromJson(jsonData);
  }

  int findIndexByName(String districtName) {
    if(districtName == null) {
      return null;
    }
    return this.l.indexWhere((element) => element.name == districtName);
  }
}
