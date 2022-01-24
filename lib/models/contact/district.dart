import 'dart:convert';

class District {
  final String zip;
  final String name;    

  District({
    required this.zip,
    required this.name,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      zip: json['zip'],
      name: json['name'],
    );
  }

  static List<District> districtListFromJson(List<dynamic>  jsonList) {
    return jsonList.map<District>((json) => District.fromJson(json)).toList();
  }

  static List<District> parseDistrictList(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return districtListFromJson(parsed);
  }


  static int findDistrictListIndexByName(List<District> districtList, String districtName) {
    return districtList.indexWhere((element) => element.name == districtName);
  }
}