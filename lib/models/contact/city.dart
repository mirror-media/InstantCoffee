import 'dart:convert';

import 'package:readr_app/models/contact/district.dart';

class City {
  final String name;
  final List<District>? districtList;    

  City({
    required this.name,
    this.districtList,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      districtList: District.districtListFromJson(json['districts'])
    );
  }

  static List<City> cityListFromJson(List<dynamic> jsonList) {
    return jsonList.map<City>((json) => City.fromJson(json)).toList();
  }

  static List<City> parseCityList(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return cityListFromJson(parsed);
  }

  static int findCityListIndexByName(List<City> cityList, String cityName) {
    return cityList.indexWhere((element) => element.name == cityName);
  }
}