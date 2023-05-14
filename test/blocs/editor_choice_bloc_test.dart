import 'package:flutter_test/flutter_test.dart';
import 'package:readr_app/blocs/editorChoice/cubit.dart';
import 'package:readr_app/blocs/editorChoice/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/editor_choice_service.dart';

class EditorChoiceTestService implements EditorChoiceRepos {
  @override
  Future<List<Record>> fetchRecordList() async {
    List<Record> result = [];
    return result;
  }
}

void main() {
  late EditorChoiceCubit editorChoiceCubit;

  setUp(() {
    editorChoiceCubit =
        EditorChoiceCubit(editorChoiceRepos: EditorChoiceTestService());
  });

  group('Editor choice bloc:', () {
    test('initial state is correct', () {
      expect(editorChoiceCubit.state, EditorChoiceState.init());
    });

    test('fetch editor choice record list', () {
      final expectedResponse = [
        EditorChoiceState.loading(),
        EditorChoiceState.loaded(editorChoiceList: const []),
      ];

      expectLater(
        editorChoiceCubit.stream,
        emitsInOrder(expectedResponse),
      );

      editorChoiceCubit.fetchEditorChoiceRecordList();
    });
  });
}
