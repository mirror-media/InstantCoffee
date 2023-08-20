import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/tagPage/states.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/record_list_and_all_count.dart';
import 'package:readr_app/services/tag_service.dart';
import 'package:readr_app/widgets/logger.dart';

class TagPageCubit extends Cubit<TagPageState> with Logger {
  TagPageCubit() : super(TagPageState.init());
  final TagService _tagService = TagService();
  final ArticlesApiProvider articlesApiProvider = Get.find();

  void fetchTagStoryList(String tagId) async {
    debugLog('Fetch tag story list');
    emit(TagPageState.loading());

    _tagService.initialPage();
    RecordListAndAllCount recordListAndAllCount =
    await _tagService.fetchRecordList(tagId);
    try {

      emit(TagPageState.loaded(
          tagStoryList: recordListAndAllCount.recordList,
          tagListTotal: recordListAndAllCount.allCount));
    } catch (e) {
      debugLog(e.toString());
      emit(TagPageState.error(errorMessages: e));
    }
  }

  void fetchNextPage(String tagId) async {
    debugLog('Fetch tag story list next page');
    try {
      List<Record> recordList = state.tagStoryList!;
      emit(TagPageState.loadingMore(
          tagStoryList: recordList, tagListTotal: state.tagListTotal!));
      _tagService.nextPage();
      RecordListAndAllCount recordListAndAllCount =
          await _tagService.fetchRecordList(tagId);
      recordList.addAll(recordListAndAllCount.recordList);
      emit(TagPageState.loaded(
          tagStoryList: recordList,
          tagListTotal: recordListAndAllCount.allCount));
    } catch (e) {
      debugLog(e.toString());
      _tagService.page = _tagService.page - 1;
      emit(TagPageState.loadingMoreFail(
        tagStoryList: state.tagStoryList!,
        tagListTotal: state.tagListTotal!,
        errorMessages: e,
      ));
    }
  }
}
