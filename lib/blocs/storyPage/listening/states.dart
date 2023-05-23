import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/record.dart';

abstract class ListeningStoryState {}

class ListeningStoryInitState extends ListeningStoryState {}

class ListeningStoryLoading extends ListeningStoryState {}

class ListeningStoryLoaded extends ListeningStoryState {
  final Listening listening;
  final List<Record> recordList;
  ListeningStoryLoaded({
    required this.listening,
    required this.recordList,
  });
}

class ListeningStoryError extends ListeningStoryState {
  final dynamic error;
  ListeningStoryError({this.error});
}
