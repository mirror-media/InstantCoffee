import 'package:readr_app/models/districtList.dart';

class City {
  final String name;
  final DistrictList districtList;    

  City({
    this.name,
    this.districtList,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      districtList: DistrictList.fromJson(json['districts']),
    );
  }
}