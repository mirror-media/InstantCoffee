class SectionAd {
  final String aT1UnitId;
  final String aT2UnitId;
  final String aT3UnitId;
  final String stUnitId;

  SectionAd({
    this.aT1UnitId,
    this.aT2UnitId,
    this.aT3UnitId,
    this.stUnitId
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