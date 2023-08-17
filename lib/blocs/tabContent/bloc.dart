import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/tabContent/events.dart';
import 'package:readr_app/blocs/tabContent/states.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/record_service.dart';
import 'package:readr_app/widgets/logger.dart';

export 'events.dart';
export 'states.dart';

class TabContentBloc extends Bloc<TabContentEvents, TabContentState>
    with Logger {
  final ArticlesApiProvider articlesApiProvider = Get.find();
  final RecordRepos recordRepos;

  TabContentBloc({required this.recordRepos})
      : super(TabContentState.initial()) {
    on<FetchFirstRecordList>(_fetchFirstRecordList);
    on<FetchNextPageRecordList>(_fetchNextPageRecordList);
  }

  void _fetchFirstRecordList(
    FetchFirstRecordList event,
    Emitter<TabContentState> emit,
  ) async {
    debugLog(event.toString());

    try {
      emit(TabContentState.initial());

      List<Record> recordList = [];

      if (event.sectionType == 'section') {
        recordList = await articlesApiProvider.getArticleListBySection(
            section: event.sectionName);
      } else if (event.sectionKey == 'latest') {
        recordList = await articlesApiProvider.getHomePageLatestArticleList();
      } else if (event.sectionKey == 'popular') {
        recordList = await articlesApiProvider.getPopularArticleList();
      } else if (event.sectionKey == 'personal') {}

      emit(TabContentState.loaded(
        hasNextPage: recordList.isNotEmpty,
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
    debugLog(event.toString());
    List<Record> recordList = state.recordList!;
    try {
      emit(TabContentState.loadingMore(recordList: recordList));

      late List<Record> newRecordList;
      if (event.isLatest) {
        newRecordList = await recordRepos.fetchLatestNextPageRecordList();
      } else {
        newRecordList =
            await recordRepos.fetchNextPageRecordList(event.sectionName);
      }

      newRecordList =
          Record.filterDuplicatedSlugByAnother(newRecordList, recordList);
      recordList.addAll(newRecordList);

      emit(TabContentState.loaded(
        hasNextPage: newRecordList.isNotEmpty,
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
