abstract class TabContentEvents{}

class FetchFirstRecordList extends TabContentEvents {
  final String sectionKey;
  final String sectionName;
  final String sectionType;
  FetchFirstRecordList({
    required this.sectionName,
    required this.sectionKey,
    required this.sectionType,
  });

  @override
  String toString() => 'FetchFirstRecordList { sectionKey: $sectionKey, sectionType: $sectionType }';
}

class FetchNextPageRecordList extends TabContentEvents {
  final String sectionName;
  final bool isLatest;
  FetchNextPageRecordList({
    required this.sectionName,
    this.isLatest = false
  });

  @override
  String toString() => 'FetchNextPageRecordList';
}