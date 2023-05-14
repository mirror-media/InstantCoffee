import 'package:readr_app/models/record.dart';

enum TagPageStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  loadingMoreFail,
  error
}

class TagPageState {
  final TagPageStatus status;
  final List<Record>? tagStoryList;
  final int? tagListTotal;
  final dynamic errorMessages;

  TagPageState({
    required this.status,
    this.tagStoryList,
    this.tagListTotal,
    this.errorMessages,
  });

  factory TagPageState.init() {
    return TagPageState(status: TagPageStatus.initial);
  }

  factory TagPageState.loading() {
    return TagPageState(status: TagPageStatus.loading);
  }

  factory TagPageState.loaded({
    required List<Record> tagStoryList,
    required int tagListTotal,
  }) {
    return TagPageState(
      status: TagPageStatus.loaded,
      tagStoryList: tagStoryList,
      tagListTotal: tagListTotal,
    );
  }

  factory TagPageState.error({errorMessages}) {
    return TagPageState(
      status: TagPageStatus.error,
      errorMessages: errorMessages,
    );
  }

  factory TagPageState.loadingMore({
    required List<Record> tagStoryList,
    required int tagListTotal,
  }) {
    return TagPageState(
      status: TagPageStatus.loadingMore,
      tagStoryList: tagStoryList,
      tagListTotal: tagListTotal,
    );
  }

  factory TagPageState.loadingMoreFail(
      {required List<Record> tagStoryList,
      required int tagListTotal,
      required errorMessages}) {
    return TagPageState(
      status: TagPageStatus.loadingMoreFail,
      tagStoryList: tagStoryList,
      tagListTotal: tagListTotal,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'TagPageState { status: $status }';
  }
}
