abstract class TabContentEvents{}

class FetchRecordList extends TabContentEvents {
  final String sectionKey;
  final String sectionType;
  FetchRecordList({
    required this.sectionKey,
    required this.sectionType,
  });

  @override
  String toString() => 'FetchRecordList { sectionKey: $sectionKey, sectionType: $sectionType }';
}

class FetchNextPageRecordList extends TabContentEvents {
  FetchNextPageRecordList();

  @override
  String toString() => 'FetchNextPageRecordList';
}