import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/newsMarquee/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/newsMarqueeService.dart';

class NewsMarqueeCubit extends Cubit<NewsMarqueeState> {
  final NewsMarqueeRepos newsMarqueeRepos;
  NewsMarqueeCubit({required this.newsMarqueeRepos}) 
      : super(NewsMarqueeState.init());

  void fetchNewsMarqueeRecordList() async {
    print('Fetch news marquee record list');
    emit(NewsMarqueeState.loading());
    try {
      List<Record> recordList = await newsMarqueeRepos.fetchRecordList();
      emit(NewsMarqueeState.loaded(recordList: recordList));
    } catch(e) {
      // fetch member subscription type fail
      print(e.toString());
      emit(NewsMarqueeState.error());
    }
  }
}