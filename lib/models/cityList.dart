import 'dart:convert';

import 'package:readr_app/models/city.dart';
import 'package:readr_app/models/customizedList.dart';

class CityList extends CustomizedList<City> {
  // constructor
  CityList();

  factory CityList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    CityList contents = CityList();

    List parseList = List();
    for (int i = 0; i < parsedJson.length; i++) {
      parseList.add(City.fromJson(parsedJson[i]));
    }

    parseList.forEach((element) {
      contents.add(element);
    });

    return contents;
  }

  factory CityList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return CityList.fromJson(jsonData);
  }


  int findIndexByName(String cityName) {
    if(cityName == null) {
      return null;
    }
    return this.l.indexWhere((element) => element.name == cityName);
  }
}
