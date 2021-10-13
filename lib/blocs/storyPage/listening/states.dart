import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/recordList.dart';

abstract class ListeningStoryState {}

class ListeningStoryInitState extends ListeningStoryState {}

class ListeningStoryLoading extends ListeningStoryState {}

class ListeningStoryLoaded extends ListeningStoryState {
  final Listening listening;
  final RecordList recordList;
  ListeningStoryLoaded({
    this.listening,
    this.recordList,
  });
}

class ListeningStoryError extends ListeningStoryState {
  final error;
  ListeningStoryError({this.error});
}
