import 'package:readr_app/models/record.dart';

enum EditorChoiceStatus { initial, loading, loaded, error }

class EditorChoiceState {
  final EditorChoiceStatus status;
  final List<Record>? editorChoiceList;
  final dynamic errorMessages;

  const EditorChoiceState({
    required this.status,
    this.editorChoiceList,
    this.errorMessages,
  });

  factory EditorChoiceState.init() {
    return EditorChoiceState(
      status: EditorChoiceStatus.initial
    );
  }

  factory EditorChoiceState.loading() {
    return EditorChoiceState(
      status: EditorChoiceStatus.loading
    );
  }

  factory EditorChoiceState.loaded({
    required List<Record> editorChoiceList,
  }) {
    return EditorChoiceState(
      status: EditorChoiceStatus.loaded,
      editorChoiceList: editorChoiceList,
    );
  }

  factory EditorChoiceState.error({
    dynamic errorMessages
  }) {
    return EditorChoiceState(
      status: EditorChoiceStatus.error,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'EditorChoiceState { status: $status }';
  }
}