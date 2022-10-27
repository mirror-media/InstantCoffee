import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/search/states.dart';
import 'package:readr_app/models/recordListAndAllCount.dart';
import 'package:readr_app/services/searchService.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepos searchRepos;
  SearchCubit({required this.searchRepos}) : super(SearchState.init());

  void searchByKeyword(String keyword) async {
    print("Searching by keyword: $keyword");
    emit(SearchState.searchLoading());
    try {
      RecordListAndAllCount recordListAndAllCount =
          await searchRepos.searchByKeyword(keyword);

      emit(SearchState.searchLoaded(
        searchStoryList: recordListAndAllCount.recordList,
        searchListTotal: recordListAndAllCount.allCount,
      ));
    } catch (e) {
      print("Search error: $e");
      emit(SearchState.searchLoadingError(
        errorMessages: e,
      ));
    }
  }

  void searchNextPageByKeyword(String keyword) async {
    print("Searching next page by keyword: $keyword");
    try {
      emit(SearchState.searchLoadingMore());

      RecordListAndAllCount recordListAndAllCount =
          await searchRepos.searchNextPageByKeyword(keyword);

      emit(SearchState.searchLoaded(
        searchStoryList: recordListAndAllCount.recordList,
        searchListTotal: recordListAndAllCount.allCount,
      ));
    } catch (e) {
      print("Search next page error: $e");
      emit(SearchState.searchLoadingMoreFail(
        errorMessages: e,
      ));
    }
  }
}
