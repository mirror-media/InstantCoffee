import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/externalStory/states.dart';
import 'package:readr_app/models/external_story.dart';
import 'package:readr_app/services/external_story_service.dart';
import 'package:readr_app/widgets/logger.dart';

class ExternalStoryCubit extends Cubit<ExternalStoryState> with Logger {
  final ExternalStoryRepos externalStoryRepos;
  ExternalStoryCubit({required this.externalStoryRepos})
      : super(ExternalStoryState.init());

  void fetchExternalStory(String slug) async {
    debugLog('Fetch external story page { slug: $slug }');
    emit(ExternalStoryState.loading());
    try {
      ExternalStory externalStory = await externalStoryRepos.fetchStory(slug);
      emit(ExternalStoryState.loaded(externalStory: externalStory));
    } catch (e) {
      emit(ExternalStoryState.error(errorMessages: e));
    }
  }
}
