import 'package:readr_app/models/record.dart';

enum TabContentStatus { 
  initial,
  loading,
  loaded,
  loadingError,
  loadingMore,
  loadingMoreFail
}

class TabContentState {
  final TabContentStatus status;
  final List<Record>? recordList;
  final dynamic errorMessages;

  /// if nextPageUrl is empty, it means no next page
  const TabContentState({
    required this.status,
    this.recordList,
    this.errorMessages,
  });

  factory TabContentState.initial() {
    return TabContentState(
      status: TabContentStatus.initial
    );
  }

  factory TabContentState.loading() {
    return TabContentState(
      status: TabContentStatus.loading
    );
  }

  factory TabContentState.loaded({
    required List<Record> recordList,
  }) {
    return TabContentState(
      status: TabContentStatus.loaded,
      recordList: recordList,
    );
  }

  factory TabContentState.loadingError({
    dynamic errorMessages,
  }) {
    return TabContentState(
      status: TabContentStatus.loadingError,
      errorMessages: errorMessages
    );
  }

  factory TabContentState.loadingMore({
    required List<Record> recordList,
  }) {
    return TabContentState(
      status: TabContentStatus.loadingMore,
      recordList: recordList,
    );
  }

  factory TabContentState.loadingMoreFail({
    required List<Record> recordList,
    dynamic errorMessages,
  }) {
    return TabContentState(
      status: TabContentStatus.loadingMoreFail,
      recordList: recordList,
      errorMessages: errorMessages
    );
  }
}