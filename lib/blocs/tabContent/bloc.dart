import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/tabContent/events.dart';
import 'package:readr_app/blocs/tabContent/states.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/recordService.dart';

export 'events.dart';
export 'states.dart';

class TabContentBloc extends Bloc<TabContentEvents, TabContentState> {
  final RecordRepos recordRepos;
  TabContentBloc({
    required this.recordRepos
  }) : super(TabContentState.initial()){
    on<FetchFirstRecordList>(_fetchFirstRecordList);
    on<FetchNextPageRecordList>(_fetchNextPageRecordList);
  }

  void _fetchFirstRecordList(
    FetchFirstRecordList event,
    Emitter<TabContentState> emit,
  ) async {
    print(event.toString());
    try{
      emit(TabContentState.initial());
      String endpoint = Environment().config.latestApi;
      if (event.sectionType == 'section') {
        endpoint = Environment().config.listingBase + '&where={"sections":{"\$in":["${event.sectionKey}"]}}';
      } else if (event.sectionKey == 'latest') {
        endpoint = Environment().config.latestApi + 'post_external01.json';
      } else if (event.sectionKey == 'popular') {
        endpoint = Environment().config.popularListApi;
      } else if (event.sectionKey == 'personal') {
        endpoint = Environment().config.listingBaseSearchByPersonAndFoodSection;
      }

      List<Record> recordList = await recordRepos.fetchRecordList(
        endpoint,
        isLoadingFirstPage: true
      );

      emit(TabContentState.loaded(
        hasNextPage: recordList.length > 0,
        recordList: recordList,
      ));
    } catch (e) {
      emit(TabContentState.loadingError(
        errorMessages: e,
      ));
    }
  }

  void _fetchNextPageRecordList(
    FetchNextPageRecordList event,
    Emitter<TabContentState> emit,
  ) async {
    print(event.toString());
    List<Record> recordList = state.recordList!;
    try{
      emit(TabContentState.loadingMore(
        recordList: recordList
      ));
      
      late List<Record> newRecordList;
      if(event.isLatest) {
        newRecordList = await recordRepos.fetchLatestNextPageRecordList();
      } else {
        newRecordList = await recordRepos.fetchNextPageRecordList();
      }
      
      newRecordList = Record.filterDuplicatedSlugByAnother(newRecordList, recordList);
      recordList.addAll(newRecordList);

      emit(TabContentState.loaded(
        hasNextPage: newRecordList.length > 0,
        recordList: recordList,
      ));
    } catch (e) {
      emit(TabContentState.loadingMoreFail(
        recordList: recordList,
        errorMessages: e,
      ));
    }
  }
}