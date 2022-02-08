import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/editorChoice/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/editorChoiceService.dart';

class EditorChoiceCubit extends Cubit<EditorChoiceState> {
  final EditorChoiceRepos editorChoiceRepos;
  EditorChoiceCubit({required this.editorChoiceRepos}) 
      : super(EditorChoiceState.init());

  void fetchEditorChoiceRecordList() async {
    print('Fetch editor choice record list');
    emit(EditorChoiceState.loading());
    try {
      List<Record> editorChoiceList = await editorChoiceRepos.fetchRecordList();
      emit(EditorChoiceState.loaded(editorChoiceList: editorChoiceList));
    } catch(e) {
      // fetch member subscription type fail
      print(e.toString());
      emit(EditorChoiceState.error());
    }
  }
}