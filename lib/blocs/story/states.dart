import 'package:readr_app/models/storyRes.dart';

abstract class StoryState {}

class StoryInitState extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final StoryRes storyRes;
  StoryLoaded({this.storyRes});
}

class StoryError extends StoryState {
  final error;
  StoryError({this.error});
}
