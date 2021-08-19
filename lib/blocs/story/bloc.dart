import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/story/events.dart';
import 'package:readr_app/blocs/story/states.dart';
import 'package:readr_app/services/storyService.dart';

class StoryBloc extends Bloc<StoryEvents, StoryState> {
  final StoryRepos storyRepos;

  StoryBloc({this.storyRepos}) : super(StoryInitState());

  @override
  Stream<StoryState> mapEventToState(StoryEvents event) async* {
    yield* event.run(storyRepos);
  }
}
