import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/search/events.dart';
import 'package:readr_app/blocs/search/states.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordListAndAllCount.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/services/searchService.dart';

class SearchBloc extends Bloc<SearchEvents, SearchState> {
  final SearchRepos searchRepos;
  SearchBloc({
    required this.searchRepos
  }) : super(SearchState.init()){
    on<FetchSectionList>(_fetchSectionList);
    on<ChangeTargetSection>(_changeTargetSection);
    on<SearchByKeywordAndSectionName>(_searchByKeywordAndSectionName);
    on<SearchNextPageByKeywordAndSectionName>(_searchNextPageByKeywordAndSectionName);
  }

  void _fetchSectionList(
    FetchSectionList event,
    Emitter<SearchState> emit,
  ) async{
    print(event.toString());
    try{
      emit(SearchState.sectionListLoading());
      List<Section> sectionList = await searchRepos.fetchSectionList();
      Section targetSection = sectionList[0];
      emit(SearchState.sectionListLoaded(
        targetSection: targetSection,
        sectionList: sectionList,
      ));
    } catch (e) {
      emit(SearchState.sectionListLoadingError(
        errorMessages: e,
      ));
    }
  }

  void _changeTargetSection(
    ChangeTargetSection event,
    Emitter<SearchState> emit,
  ) {
    print(event.toString());
    emit(SearchState.sectionListLoaded(
      targetSection: event.section,
      sectionList: state.sectionList!,
    ));
  }

  void _searchByKeywordAndSectionName(
    SearchByKeywordAndSectionName event,
    Emitter<SearchState> emit,
  ) async{
    print(event.toString());
    try{
      emit(SearchState.searchLoading(
        targetSection: state.targetSection!,
        sectionList: state.sectionList!
      ));

      RecordListAndAllCount recordListAndAllCount = await searchRepos.searchByKeywordAndSectionName(
        event.keyword, 
        sectionName: event.sectionName
      );

      emit(SearchState.searchLoaded(
        targetSection: state.targetSection!,
        sectionList: state.sectionList!,
        searchStoryList: recordListAndAllCount.recordList,
        searchListTotal: recordListAndAllCount.allCount,
      ));
    } catch (e) {
      emit(SearchState.searchLoadingError(
        targetSection: state.targetSection!,
        sectionList: state.sectionList!,
        errorMessages: e,
      ));
    }
  }

  void _searchNextPageByKeywordAndSectionName(
    SearchNextPageByKeywordAndSectionName event,
    Emitter<SearchState> emit,
  ) async{
    print(event.toString());
    try{
      List<Record> searchStoryList = state.searchStoryList!;
      emit(SearchState.searchLoadingMore(
        targetSection: state.targetSection!,
        sectionList: state.sectionList!,
        searchStoryList: searchStoryList,
        searchListTotal: state.searchListTotal!,
      ));

      RecordListAndAllCount recordListAndAllCount = await searchRepos.searchNextPageByKeywordAndSectionName(
        event.keyword, 
        sectionName: event.sectionName
      );

      searchStoryList.addAll(recordListAndAllCount.recordList);

      emit(SearchState.searchLoaded(
        targetSection: state.targetSection!,
        sectionList: state.sectionList!,
        searchStoryList: searchStoryList,
        searchListTotal: recordListAndAllCount.allCount,
      ));
    } catch (e) {
      searchRepos.reducePage(1);
      emit(SearchState.searchLoadingMoreFail(
        targetSection: state.targetSection!,
        sectionList: state.sectionList!,
        searchStoryList: state.searchStoryList!,
        searchListTotal: state.searchListTotal!,
        errorMessages: e,
      ));
    }
  }
}
