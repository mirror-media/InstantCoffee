import 'dart:convert';

class Country {
  final String iSO2;
  final String taiwanName;
  final String englishName;        

  Country({
    required this.iSO2,
    required this.taiwanName,
    required this.englishName,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      iSO2: json['ISO2'],
      taiwanName: json['Taiwan'],
      englishName: json['English'],
    );
  }

  static List<Country> countryListFromJson(List<Map<String, dynamic> > jsonList) {
    return jsonList.map<Country>((json) => Country.fromJson(json)).toList();
  }

  static List<Country> parseCountryList(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return countryListFromJson(parsed);
  }

  static int findCountryListIndexByTaiwanName(List<Country> countryList, String taiwanCountryName) {
    return countryList.indexWhere((element) => element.taiwanName == taiwanCountryName);
  }
}