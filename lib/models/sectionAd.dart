class SectionAd {
  final String aT1UnitId;
  final String aT2UnitId;
  final String aT3UnitId;
  final String stUnitId;

  SectionAd({
    required this.aT1UnitId,
    required this.aT2UnitId,
    required this.aT3UnitId,
    required this.stUnitId
  });

  factory SectionAd.fromJson(Map<String, dynamic> json) {
    return SectionAd(
      aT1UnitId: json['AT1'],
      aT2UnitId: json['AT2'],
      aT3UnitId: json['AT3'],
      stUnitId: json['ST'],
    );
  }
}