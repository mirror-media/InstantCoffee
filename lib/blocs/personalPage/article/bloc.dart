import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/personalPage/article/events.dart';
import 'package:readr_app/blocs/personalPage/article/states.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/personal_subscription_service.dart';
import 'package:readr_app/widgets/logger.dart';

import '../../../data/providers/articles_api_provider.dart';

class PersonalArticleBloc
    extends Bloc<PersonalArticleEvents, PersonalArticleState> with Logger {
  final PersonalSubscriptionRepos personalSubscriptionRepos;
  PersonalArticleBloc({required this.personalSubscriptionRepos})
      : super(PersonalArticleState.init()) {
    on<FetchSubscribedArticleList>(_fetchSubscribedArticleList);
    on<FetchNextPageSubscribedArticleList>(_fetchNextPageSubscribedArticleList);
  }

  bool isNextPageEmpty = false;
  final ArticlesApiProvider articleApiProvider =Get.find();

  void _fetchSubscribedArticleList(
    FetchSubscribedArticleList event,
    Emitter<PersonalArticleState> emit,
  ) async {
    debugLog(event.toString());
    List<Record> subscribedArticleList = [];
    List<Category> subscriptionIdStringList = event.subscribedCategoryList;
    if (subscriptionIdStringList.isNotEmpty) {
      subscribedArticleList = await personalSubscriptionRepos
          .fetchRecordList(subscriptionIdStringList, page: 1);
    }
    try {
      emit(PersonalArticleState.subscribedArticleListLoading());

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
    List<Category> subscriptionIdStringList = event.subscribedCategoryList;
    try {
      emit(PersonalArticleState.subscribedArticleListLoadingMore(
          subscribedArticleList: subscribedArticleList));
      if (subscriptionIdStringList.isNotEmpty) {
        List<Record> newSubscribedArticleList = await personalSubscriptionRepos
            .fetchNextRecordList(subscriptionIdStringList);
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
