import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/personalPage/article/events.dart';
import 'package:readr_app/blocs/personalPage/article/states.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/personal_subscription_service.dart';
import 'package:readr_app/widgets/logger.dart';

class PersonalArticleBloc
    extends Bloc<PersonalArticleEvents, PersonalArticleState> with Logger {
  final PersonalSubscriptionRepos personalSubscriptionRepos;
  PersonalArticleBloc({required this.personalSubscriptionRepos})
      : super(PersonalArticleState.init()) {
    on<FetchSubscribedArticleList>(_fetchSubscribedArticleList);
    on<FetchNextPageSubscribedArticleList>(_fetchNextPageSubscribedArticleList);
  }

  bool isNextPageEmpty = false;

  void _fetchSubscribedArticleList(
    FetchSubscribedArticleList event,
    Emitter<PersonalArticleState> emit,
  ) async {
    debugLog(event.toString());
    try {
      emit(PersonalArticleState.subscribedArticleListLoading());

      List<Record> subscribedArticleList = [];
      List<String> subscriptionIdStringList =
          Category.getSubscriptionIdStringList(event.subscribedCategoryList);
      if (subscriptionIdStringList.isNotEmpty) {
        String categoryListJson = json.encode(subscriptionIdStringList);
        subscribedArticleList = await personalSubscriptionRepos
            .fetchRecordList(categoryListJson, page: 1);
      }

      emit(PersonalArticleState.subscribedArticleListLoaded(
        subscribedArticleList: subscribedArticleList,
      ));
    } catch (e) {
      emit(PersonalArticleState.subscribedArticleListLoadingError(
        errorMessages: e,
      ));
    }
  }

  void _fetchNextPageSubscribedArticleList(
    FetchNextPageSubscribedArticleList event,
    Emitter<PersonalArticleState> emit,
  ) async {
    debugLog(event.toString());
    List<Record> subscribedArticleList = state.subscribedArticleList!;
    try {
      emit(PersonalArticleState.subscribedArticleListLoadingMore(
          subscribedArticleList: subscribedArticleList));

      List<String> subscriptionIdStringList =
          Category.getSubscriptionIdStringList(event.subscribedCategoryList);
      if (subscriptionIdStringList.isNotEmpty) {
        String categoryListJson = json.encode(subscriptionIdStringList);
        List<Record> newSubscribedArticleList = await personalSubscriptionRepos
            .fetchNextRecordList(categoryListJson);
        isNextPageEmpty = newSubscribedArticleList.isEmpty;
        subscribedArticleList.addAll(newSubscribedArticleList);
      }

      emit(PersonalArticleState.subscribedArticleListLoaded(
        subscribedArticleList: subscribedArticleList,
      ));
    } catch (e) {
      personalSubscriptionRepos.previousPage();
      emit(PersonalArticleState.subscribedArticleListLoadingMoreFail(
        subscribedArticleList: subscribedArticleList,
        errorMessages: e,
      ));
    }
  }
}
