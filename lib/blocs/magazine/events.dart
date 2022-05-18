abstract class MagazineEvents {}

class FetchMagazineListByType extends MagazineEvents {
  final String type;
  final int page;
  final int maxResult;
  FetchMagazineListByType(
    this.type, {
    this.page = 1,
    this.maxResult = 8,
  });

  @override
  String toString() => 'FetchMagazineListByType { type: $type }';
}

class FetchNextMagazineListPageByType extends MagazineEvents {
  final String type;
  final int maxResult;
  FetchNextMagazineListPageByType(
    this.type, {
    this.maxResult = 8,
  });

  @override
  String toString() => 'FetchMagazineListByType { type: $type }';
}
