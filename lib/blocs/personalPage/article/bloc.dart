import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/personalPage/article/events.dart';
import 'package:readr_app/blocs/personalPage/article/states.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/personalSubscriptionService.dart';

class PersonalArticleBloc extends Bloc<PersonalArticleEvents, PersonalArticleState> {
  final PersonalSubscriptionRepos personalSubscriptionRepos;
  PersonalArticleBloc({
    required this.personalSubscriptionRepos
  }) : super(PersonalArticleState.init()){
    on<FetchSubscribedArticleList>(_fetchSubscribedArticleList);
    on<FetchNextPageSubscribedArticleList>(_fetchNextPageSubscribedArticleList);
  }

  bool isNextPageEmpty = false;

  void _fetchSubscribedArticleList(
    FetchSubscribedArticleList event,
    Emitter<PersonalArticleState> emit,
  ) async {
    print(event.toString());
    try{
      emit(PersonalArticleState.subscribedArticleListLoading());

      List<Record> subscribedArticleList = [];
      List<String> subscriptionIdStringList = Category.getSubscriptionIdStringList(event.subscribedCategoryList);
      if(subscriptionIdStringList.length != 0) {
        String categoryListJson = json.encode(subscriptionIdStringList);
        subscribedArticleList = await personalSubscriptionRepos.fetchRecordList(categoryListJson, page: 1);
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
    print(event.toString());
    List<Record> subscribedArticleList = state.subscribedArticleList!;
    try{
      emit(PersonalArticleState.subscribedArticleListLoadingMore(
        subscribedArticleList: subscribedArticleList
      ));

      List<String> subscriptionIdStringList = Category.getSubscriptionIdStringList(event.subscribedCategoryList);
      if(subscriptionIdStringList.length != 0) {
        String categoryListJson = json.encode(subscriptionIdStringList);
        List<Record> newSubscribedArticleList = await personalSubscriptionRepos.fetchNextRecordList(categoryListJson);
        isNextPageEmpty = newSubscribedArticleList.length == 0;
        subscribedArticleList.addAll(newSubscribedArticleList);
      }

      emit(PersonalArticleState.subscribedArticleListLoaded(
        subscribedArticleList: subscribedArticleList,
      ));
    } catch (e) {
      emit(PersonalArticleState.subscribedArticleListLoadingMoreFail(
        subscribedArticleList: subscribedArticleList,
        errorMessages: e,
      ));
    }
  }
}
