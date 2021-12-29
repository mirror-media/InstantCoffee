part of 'cubit.dart';

@immutable
abstract class TagPageState {}

class TagPageInitial extends TagPageState {}

class TagPageLoading extends TagPageState {}

class TagPageLoaded extends TagPageState {
  final RecordList tagStoryList;
  TagPageLoaded(this.tagStoryList);
}

class TagPageLoadingNextPage extends TagPageState {}

class TagPageError extends TagPageState {
  final dynamic error;
  TagPageError(this.error);
}

class TagPageLoadNextPageFailed extends TagPageState {
  final dynamic error;
  final RecordList tagStoryList;
  TagPageLoadNextPageFailed(this.error, this.tagStoryList);
}
