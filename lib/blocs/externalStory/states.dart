import 'package:readr_app/models/external_story.dart';

enum ExternalStoryStatus { initial, loading, loaded, error }

class ExternalStoryState {
  final ExternalStoryStatus status;
  final ExternalStory? externalStory;
  final dynamic errorMessages;

  const ExternalStoryState({
    required this.status,
    this.externalStory,
    this.errorMessages,
  });

  factory ExternalStoryState.init() {
    return const ExternalStoryState(
      status: ExternalStoryStatus.initial,
    );
  }

  factory ExternalStoryState.loading() {
    return const ExternalStoryState(status: ExternalStoryStatus.loading);
  }

  factory ExternalStoryState.loaded({
    required ExternalStory externalStory,
  }) {
    return ExternalStoryState(
      status: ExternalStoryStatus.loaded,
      externalStory: externalStory,
    );
  }

  factory ExternalStoryState.error({errorMessages}) {
    return ExternalStoryState(
      status: ExternalStoryStatus.error,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'ExternalStoryState { status: $status }';
  }
}
