abstract class TabContentEvents{}

class FetchFirstRecordList extends TabContentEvents {
  final String sectionKey;
  final String sectionType;
  FetchFirstRecordList({
    required this.sectionKey,
    required this.sectionType,
  });

  @override
  String toString() => 'FetchFirstRecordList { sectionKey: $sectionKey, sectionType: $sectionType }';
}

class FetchNextPageRecordList extends TabContentEvents {
  final bool isLatest;
  FetchNextPageRecordList({
    this.isLatest = false
  });

  @override
  String toString() => 'FetchNextPageRecordList';
}