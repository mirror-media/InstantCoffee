import 'package:bloc/bloc.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordListAndAllCount.dart';
import 'package:readr_app/services/tagService.dart';
import 'package:readr_app/blocs/tagPage/states.dart';

class TagPageCubit extends Cubit<TagPageState> {
  TagPageCubit() : super(TagPageState.init());
  TagService _tagService = TagService();

  void fetchTagStoryList(String tagId) async{
    print('Fetch tag story list');
    emit(TagPageState.loading());
    try{
      String url = Environment().config.apiBase + 'getposts?where={"tags":{"\$in":["$tagId"]},"isAdvertised":false,"isAdult":false,"isAudioSiteOnly":false,"state":{"\$nin":["invisible"]},"categories":{"\$nin":["57fca2f5c9b7a70e004e6df9","5ea94861a66f9e0f00a0503f"]}}&sort=-updatedAt&embedded={"relateds":1}&related=full&keep=draft';
      _tagService.initialPage();
      RecordListAndAllCount recordListAndAllCount = await _tagService.fetchRecordList(url);
      emit(TagPageState.loaded(
        tagStoryList: recordListAndAllCount.recordList, 
        tagListTotal: recordListAndAllCount.allCount
      ));
    }catch(e){
      print(e.toString());
      emit(TagPageState.error(errorMessages: e));
    }
  }

  void fetchNextPage() async{
    print('Fetch tag story list next page');
    try{
      List<Record> recordList = state.tagStoryList!;
      emit(TagPageState.loadingMore(
        tagStoryList: recordList, 
        tagListTotal: state.tagListTotal!
      ));
      _tagService.nextPage();
      RecordListAndAllCount recordListAndAllCount = await _tagService.fetchRecordList(_tagService.getNextUrl);
      recordList.addAll(recordListAndAllCount.recordList);
      emit(TagPageState.loaded(
        tagStoryList: recordList, 
        tagListTotal: recordListAndAllCount.allCount
      ));
    }catch(e){
      print(e.toString());
      _tagService.page = _tagService.page -1;
      emit(TagPageState.loadingMoreFail(
        tagStoryList: state.tagStoryList!, 
        tagListTotal: state.tagListTotal!,
        errorMessages: e,
      ));
    }
  }
}
