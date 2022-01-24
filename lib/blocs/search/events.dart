import 'package:readr_app/models/section.dart';

abstract class SearchEvents{}

class FetchSectionList extends SearchEvents {
  @override
  String toString() => 'FetchSectionList';
}

class ChangeTargetSection extends SearchEvents {
  final Section section;
  ChangeTargetSection(
    this.section
  );

  @override
  String toString() => 'ChangeTargetSection: targetSection: ${section.name}';
}

class SearchByKeywordAndSectionName extends SearchEvents {
  final String keyword;
  final String sectionName;
  SearchByKeywordAndSectionName(
    this.keyword,
    {this.sectionName = ''}
  );

  @override
  String toString() => 'SearchByKeywordAndSectionId { keyword: $keyword, sectionName: $sectionName }';
}

class SearchNextPageByKeywordAndSectionName extends SearchEvents {
  final String keyword;
  final String sectionName;
  SearchNextPageByKeywordAndSectionName(
    this.keyword,
    {this.sectionName = ''}
  );

  @override
  String toString() => 'SearchNextPageByKeywordAndSectionName { keyword: $keyword, sectionName: $sectionName }';
}