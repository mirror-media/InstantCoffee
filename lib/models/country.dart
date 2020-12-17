class Country {
  final String iSO2;
  final String taiwanName;
  final String englishName;        

  Country({
    this.iSO2,
    this.taiwanName,
    this.englishName,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      iSO2: json['ISO2'],
      taiwanName: json['Taiwan'],
      englishName: json['English'],
    );
  }
}