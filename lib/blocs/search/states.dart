import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionList.dart';

abstract class SearchState {}

class SearchPageInitState extends SearchState {}

class SearchPageLoading extends SearchState {}

class SearchPageLoaded extends SearchState {
  final Section targetSection;
  final SectionList sectionList;
  SearchPageLoaded({
    this.targetSection,
    this.sectionList
  });
}

class SearchPageError extends SearchState {
  final error;
  SearchPageError({this.error});
}

class SearchLoading extends SearchPageLoaded {
  SearchLoading({
    Section targetSection,
    SectionList sectionList,
  }) : super(targetSection: targetSection, sectionList: sectionList);
}

class SearchLoadingMore extends SearchPageLoaded {
  final RecordList searchList;
  SearchLoadingMore({
    Section targetSection,
    SectionList sectionList,
    this.searchList
  }) : super(targetSection: targetSection, sectionList: sectionList);
}

class SearchLoaded extends SearchPageLoaded {
  final RecordList searchList;
  SearchLoaded({
    Section targetSection,
    SectionList sectionList,
    this.searchList
  }) : super(targetSection: targetSection, sectionList: sectionList);
}

class SearchError extends SearchPageLoaded {
  final error;
  SearchError({
    Section targetSection,
    SectionList sectionList,
    this.error
  }) : super(targetSection: targetSection, sectionList: sectionList);
}
