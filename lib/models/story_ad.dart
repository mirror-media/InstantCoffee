class StoryAd {
  final String hDUnitId;
  final String fTUnitId;
  final String aT1UnitId;
  final String aT2UnitId;
  final String aT3UnitId;
  final String e1UnitId;
  final String stUnitId;

  StoryAd({
    required this.hDUnitId,
    required this.fTUnitId,
    required this.aT1UnitId,
    required this.aT2UnitId,
    required this.aT3UnitId,
    required this.e1UnitId,
    required this.stUnitId
  });

  factory StoryAd.fromJson(Map<String, dynamic> json) {
    return StoryAd(
      hDUnitId: json['HD'],
      fTUnitId: json['FT'],
      aT1UnitId: json['AT1'],
      aT2UnitId: json['AT2'],
      aT3UnitId: json['AT3'],
      e1UnitId: json['E1'],
      stUnitId: json['ST'],
    );
  }
}