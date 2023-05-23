import 'package:readr_app/models/story_res.dart';

enum StoryStatus { initial, loading, loaded, error }

class StoryState {
  final StoryStatus status;
  final String storySlug;
  final StoryRes? storyRes;
  final dynamic errorMessages;

  const StoryState({
    required this.status,
    required this.storySlug,
    this.storyRes,
    this.errorMessages,
  });

  factory StoryState.init({required String storySlug}) {
    return StoryState(status: StoryStatus.initial, storySlug: storySlug);
  }

  factory StoryState.loading({required String storySlug}) {
    return StoryState(status: StoryStatus.loading, storySlug: storySlug);
  }

  factory StoryState.loaded({
    required String storySlug,
    required StoryRes storyRes,
  }) {
    return StoryState(
      status: StoryStatus.loaded,
      storySlug: storySlug,
      storyRes: storyRes,
    );
  }

  factory StoryState.error({required String storySlug, errorMessages}) {
    return StoryState(
      status: StoryStatus.error,
      storySlug: storySlug,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'StoryState { status: $status, storySlug: $storySlug }';
  }
}
