import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';

enum SearchStatus { 
  initial,
  sectionListLoading,
  sectionListLoaded,
  sectionListLoadingError,

  searchLoading,
  searchLoaded,
  searchLoadingError,
  searchLoadingMore,
  searchLoadingMoreFail,
}

class SearchState {
  final SearchStatus status;
  final Section? targetSection;
  final List<Section>? sectionList;

  final List<Record>? searchStoryList;
  final int? searchListTotal;
  final dynamic errorMessages;

  SearchState({
    required this.status,
    this.targetSection,
    this.sectionList,

    this.searchStoryList,
    this.searchListTotal,
    this.errorMessages,
  });
  
  factory SearchState.init() {
    return SearchState(
      status: SearchStatus.initial
    );
  }

  factory SearchState.sectionListLoading() {
    return SearchState(
      status: SearchStatus.sectionListLoading
    );
  }

  factory SearchState.sectionListLoaded({
    required Section targetSection,
    required List<Section> sectionList,
  }) {
    return SearchState(
      status: SearchStatus.sectionListLoaded,
      targetSection: targetSection,
      sectionList: sectionList,
    );
  }

  factory SearchState.sectionListLoadingError({
    required dynamic errorMessages
  }) {
    return SearchState(
      status: SearchStatus.sectionListLoadingError,
      errorMessages: errorMessages,
    );
  }

  factory SearchState.searchLoading({
    required Section targetSection,
    required List<Section> sectionList,
  }) {
    return SearchState(
      status: SearchStatus.searchLoading,
      targetSection: targetSection,
      sectionList: sectionList,
    );
  }

  factory SearchState.searchLoaded({
    required Section targetSection,
    required List<Section> sectionList,
    required List<Record> searchStoryList,
    required int searchListTotal,
  }) {
    return SearchState(
      status: SearchStatus.searchLoaded,
      targetSection: targetSection,
      sectionList: sectionList,
      searchStoryList: searchStoryList,
      searchListTotal: searchListTotal,
    );
  }

  factory SearchState.searchLoadingError({
    required Section targetSection,
    required List<Section> sectionList,
    required dynamic errorMessages
  }) {
    return SearchState(
      status: SearchStatus.searchLoadingError,
      targetSection: targetSection,
      sectionList: sectionList,
      errorMessages: errorMessages,
    );
  }

  factory SearchState.searchLoadingMore({
    required Section targetSection,
    required List<Section> sectionList,
    required List<Record> searchStoryList,
    required int searchListTotal,
  }) {
    return SearchState(
      status: SearchStatus.searchLoadingMore,
      targetSection: targetSection,
      sectionList: sectionList,
      searchStoryList: searchStoryList,
      searchListTotal: searchListTotal,
    );
  }

  factory SearchState.searchLoadingMoreFail({
    required Section targetSection,
    required List<Section> sectionList,
    required List<Record> searchStoryList,
    required int searchListTotal,
    required dynamic errorMessages
  }) {
    return SearchState(
      status: SearchStatus.searchLoadingMoreFail,
      targetSection: targetSection,
      sectionList: sectionList,
      searchStoryList: searchStoryList,
      searchListTotal: searchListTotal,
      errorMessages: errorMessages,
    );
  }
}
