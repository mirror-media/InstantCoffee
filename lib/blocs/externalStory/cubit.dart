import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/externalStory/states.dart';
import 'package:readr_app/models/externalStory.dart';
import 'package:readr_app/services/externalStoryService.dart';

class ExternalStoryCubit extends Cubit<ExternalStoryState> {
  final ExternalStoryRepos externalStoryRepos;
  ExternalStoryCubit({required this.externalStoryRepos}) 
      : super(ExternalStoryState.init());

  void fetchExternalStory(String slug) async {
    print('Fetch external story page { slug: $slug }');
    emit(ExternalStoryState.loading());
    try{
      ExternalStory externalStory = await externalStoryRepos.fetchStory(slug);
      emit(
        ExternalStoryState.loaded(
          externalStory: externalStory
        )
      );
      
    } catch (e) {
      emit(
        ExternalStoryState.error(errorMessages: e)
      );
    }
  }
}