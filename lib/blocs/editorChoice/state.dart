import 'package:equatable/equatable.dart';
import 'package:readr_app/models/record.dart';

enum EditorChoiceStatus { initial, loading, loaded, error }

class EditorChoiceState extends Equatable {
  final EditorChoiceStatus status;
  final List<Record>? editorChoiceList;
  final dynamic errorMessages;

  const EditorChoiceState({
    required this.status,
    this.editorChoiceList,
    this.errorMessages,
  });

  factory EditorChoiceState.init() {
    return const EditorChoiceState(status: EditorChoiceStatus.initial);
  }

  factory EditorChoiceState.loading() {
    return const EditorChoiceState(status: EditorChoiceStatus.loading);
  }

  factory EditorChoiceState.loaded({
    required List<Record> editorChoiceList,
  }) {
    return EditorChoiceState(
      status: EditorChoiceStatus.loaded,
      editorChoiceList: editorChoiceList,
    );
  }

  factory EditorChoiceState.error({dynamic errorMessages}) {
    return EditorChoiceState(
      status: EditorChoiceStatus.error,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'EditorChoiceState { status: $status }';
  }

  @override
  List<Object?> get props => [status, editorChoiceList, errorMessages];
}
