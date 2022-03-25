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
    on<FetchRecordList>(_fetchRecordList);
    on<FetchNextPageRecordList>(_fetchNextPageRecordList);
  }

  bool hasNextPage = true;

  void _fetchRecordList(
    FetchRecordList event,
    Emitter<TabContentState> emit,
  ) async {
    print(event.toString());
    try{
      emit(TabContentState.initial());
      String endpoint = Environment().config.latestApi;
      if (event.sectionType == 'section') {
        endpoint = Environment().config.listingBase + '&where={"sections":{"\$in":["${event.sectionKey}"]}}';
      } else if (event.sectionKey == 'latest') {
        endpoint = Environment().config.latestApi;
      } else if (event.sectionKey == 'popular') {
        endpoint = Environment().config.popularListApi;
      } else if (event.sectionKey == 'personal') {
        endpoint = Environment().config.listingBaseSearchByPersonAndFoodSection;
      }

      recordRepos.initialService();
      List<Record> recordList = await recordRepos.fetchRecordList(endpoint);
      hasNextPage = recordList.length > 0;

      emit(TabContentState.loaded(
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
      
      List<Record> newRecordList = await recordRepos.fetchNextPageRecordList();
      hasNextPage = newRecordList.length > 0;
      newRecordList = Record.filterDuplicatedSlugByAnother(newRecordList, recordList);
      recordList.addAll(newRecordList);

      emit(TabContentState.loaded(
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