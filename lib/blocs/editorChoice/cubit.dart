import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/editorChoice/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/editor_choice_service.dart';
import 'package:readr_app/widgets/logger.dart';

class EditorChoiceCubit extends Cubit<EditorChoiceState> with Logger {
  final EditorChoiceRepos editorChoiceRepos;
  EditorChoiceCubit({required this.editorChoiceRepos})
      : super(EditorChoiceState.init());

  void fetchEditorChoiceRecordList() async {
    debugLog('Fetch editor choice record list');
    emit(EditorChoiceState.loading());
    try {
      List<Record> editorChoiceList = await editorChoiceRepos.fetchRecordList();
      emit(EditorChoiceState.loaded(editorChoiceList: editorChoiceList));
    } catch (e) {
      // fetch member subscription type fail
      debugLog(e.toString());
      emit(EditorChoiceState.error());
    }
  }
}
