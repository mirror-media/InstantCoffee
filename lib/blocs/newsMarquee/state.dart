import 'package:equatable/equatable.dart';
import 'package:readr_app/models/record.dart';

enum NewsMarqueeStatus { initial, loading, loaded, error }

class NewsMarqueeState extends Equatable {
  final NewsMarqueeStatus status;
  final List<Record>? recordList;
  final dynamic errorMessages;

  const NewsMarqueeState({
    required this.status,
    this.recordList,
    this.errorMessages,
  });

  factory NewsMarqueeState.init() {
    return NewsMarqueeState(
      status: NewsMarqueeStatus.initial
    );
  }

  factory NewsMarqueeState.loading() {
    return NewsMarqueeState(
      status: NewsMarqueeStatus.loading
    );
  }

  factory NewsMarqueeState.loaded({
    required List<Record> recordList,
  }) {
    return NewsMarqueeState(
      status: NewsMarqueeStatus.loaded,
      recordList: recordList,
    );
  }

  factory NewsMarqueeState.error({
    dynamic errorMessages
  }) {
    return NewsMarqueeState(
      status: NewsMarqueeStatus.error,
      errorMessages: errorMessages,
    );
  }

  @override
  String toString() {
    return 'NewsMarqueeState { status: $status }';
  }

  @override
  List<Object?> get props => [
    status, 
    recordList, 
    errorMessages
  ];
}