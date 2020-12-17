import 'dart:convert';

import 'package:readr_app/models/country.dart';
import 'package:readr_app/models/customizedList.dart';

class CountryList extends CustomizedList<Country> {
  // constructor
  CountryList();

  factory CountryList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    CountryList contents = CountryList();

    List parseList = List();
    for (int i = 0; i < parsedJson.length; i++) {
      parseList.add(Country.fromJson(parsedJson[i]));
    }

    parseList.forEach((element) {
      contents.add(element);
    });

    return contents;
  }

  factory CountryList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return CountryList.fromJson(jsonData);
  }

  int findIndexByTaiwanName(String taiwanCountryName) {
    return this.l.indexWhere((element) => element.taiwanName == taiwanCountryName);
  }
}
