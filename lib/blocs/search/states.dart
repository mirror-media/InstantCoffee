import 'package:readr_app/models/record.dart';

enum SearchStatus {
  initial,
  searchLoading,
  searchLoaded,
  searchLoadingError,
  searchLoadingMore,
  searchLoadingMoreFail,
}

class SearchState {
  final SearchStatus status;

  final List<Record>? searchStoryList;
  final int? searchListTotal;
  final dynamic errorMessages;

  SearchState({
    required this.status,
    this.searchStoryList,
    this.searchListTotal,
    this.errorMessages,
  });

  factory SearchState.init() {
    return SearchState(status: SearchStatus.initial);
  }

  factory SearchState.searchLoading() {
    return SearchState(
      status: SearchStatus.searchLoading,
    );
  }

  factory SearchState.searchLoaded({
    required List<Record> searchStoryList,
    required int searchListTotal,
  }) {
    return SearchState(
      status: SearchStatus.searchLoaded,
      searchStoryList: searchStoryList,
      searchListTotal: searchListTotal,
    );
  }

  factory SearchState.searchLoadingError({required dynamic errorMessages}) {
    return SearchState(
      status: SearchStatus.searchLoadingError,
      errorMessages: errorMessages,
    );
  }

  factory SearchState.searchLoadingMore() {
    return SearchState(
      status: SearchStatus.searchLoadingMore,
    );
  }

  factory SearchState.searchLoadingMoreFail({required dynamic errorMessages}) {
    return SearchState(
      status: SearchStatus.searchLoadingMoreFail,
      errorMessages: errorMessages,
    );
  }
}
