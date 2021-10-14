import 'package:readr_app/models/storyRes.dart';

enum StoryStatus { initial, loading, loaded, error }

class StoryState {
  final StoryStatus status;
  final StoryRes storyRes;
  final errorMessages;

  const StoryState({
    this.status,
    this.storyRes,
    this.errorMessages,
  });

  factory StoryState.init() {
    return StoryState(
      status: StoryStatus.initial
    );
  }

  factory StoryState.loading() {
    return StoryState(
      status: StoryStatus.loading
    );
  }

  factory StoryState.loaded({
    StoryRes storyRes,
  }) {
    return StoryState(
      status: StoryStatus.loaded,
      storyRes: storyRes,
    );
  }

  factory StoryState.error({
    errorMessages
  }) {
    return StoryState(
      status: StoryStatus.error,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'StoryState { status: $status }';
  }
}
