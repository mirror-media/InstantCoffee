import 'package:readr_app/models/record.dart';

enum PersonalArticleStatus { 
  initial,
  subscribedArticleListLoading,
  subscribedArticleListLoaded,
  subscribedArticleListLoadingError,
  subscribedArticleListLoadingMore,
  subscribedArticleListLoadingMoreFail,
}

class PersonalArticleState {
  final PersonalArticleStatus status;
  final List<Record>? subscribedArticleList;
  final dynamic errorMessages;

  const PersonalArticleState({
    required this.status,
    this.subscribedArticleList,
    this.errorMessages,
  });

  factory PersonalArticleState.init() {
    return PersonalArticleState(
      status: PersonalArticleStatus.initial
    );
  }

  factory PersonalArticleState.subscribedArticleListLoading() {
    return PersonalArticleState(
      status: PersonalArticleStatus.subscribedArticleListLoading,
    );
  }

  factory PersonalArticleState.subscribedArticleListLoaded({
    required List<Record> subscribedArticleList
  }) {
    return PersonalArticleState(
      status: PersonalArticleStatus.subscribedArticleListLoaded,
      subscribedArticleList: subscribedArticleList,
    );
  }

  factory PersonalArticleState.subscribedArticleListLoadingError({
    dynamic errorMessages,
  }) {
    return PersonalArticleState(
      status: PersonalArticleStatus.subscribedArticleListLoadingError,
      errorMessages: errorMessages
    );
  }

  factory PersonalArticleState.subscribedArticleListLoadingMore({
    required List<Record> subscribedArticleList
  }) {
    return PersonalArticleState(
      status: PersonalArticleStatus.subscribedArticleListLoadingMore,
      subscribedArticleList: subscribedArticleList,
    );
  }

  factory PersonalArticleState.subscribedArticleListLoadingMoreFail({
    required List<Record> subscribedArticleList,
    dynamic errorMessages,
  }) {
    return PersonalArticleState(
      status: PersonalArticleStatus.subscribedArticleListLoadingMoreFail,
      subscribedArticleList: subscribedArticleList,
      errorMessages: errorMessages
    );
  }

  @override
  String toString() {
    return 'PersonalArticleState { status: $status }';
  }
}
