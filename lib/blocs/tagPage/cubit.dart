import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/services/tagService.dart';

part 'state.dart';

class TagPageCubit extends Cubit<TagPageState> {
  TagPageCubit() : super(TagPageInitial());
  RecordList _recordList = RecordList();
  TagService _tagService = TagService();

  void fetchTagStoryList(String tagId) async{
    print('Fetch tag story list');
    emit(TagPageLoading());
    try{
      String url = Environment().config.apiBase + 'getposts?where={"tags":{"\$in":["$tagId"]},"isAdvertised":false,"isAdult":false,"isAudioSiteOnly":false,"state":{"\$nin":["invisible"]},"categories":{"\$nin":["57fca2f5c9b7a70e004e6df9","5ea94861a66f9e0f00a0503f"]}}&sort=-updatedAt&embedded={"relateds":1}&related=full&keep=draft';
      _tagService.initialPage();
      _recordList = await _tagService.fetchRecordList(url);
      emit(TagPageLoaded(_recordList));
    }catch(e){
      print(e.toString());
      emit(TagPageError(e));
    }
  }

  void fetchNextPage() async{
    print('Fetch tag story list next page');
    emit(TagPageLoadingNextPage());
    try{
      _tagService.nextPage();
      RecordList newRecordList = await _tagService.fetchRecordList(_tagService.getNextUrl);
      _recordList.addAll(newRecordList);
      emit(TagPageLoaded(_recordList));
    }catch(e){
      print(e.toString());
      emit(TagPageLoadNextPageFailed(e,_recordList));
    }
  }
}
