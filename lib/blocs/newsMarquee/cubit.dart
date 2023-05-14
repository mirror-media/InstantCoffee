import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/newsMarquee/state.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/news_marquee_service.dart';
import 'package:readr_app/widgets/logger.dart';

class NewsMarqueeCubit extends Cubit<NewsMarqueeState> with Logger {
  final NewsMarqueeRepos newsMarqueeRepos;
  NewsMarqueeCubit({required this.newsMarqueeRepos})
      : super(NewsMarqueeState.init());

  void fetchNewsMarqueeRecordList() async {
    debugLog('Fetch news marquee record list');
    emit(NewsMarqueeState.loading());
    try {
      List<Record> recordList = await newsMarqueeRepos.fetchRecordList();
      emit(NewsMarqueeState.loaded(recordList: recordList));
    } catch (e) {
      // fetch member subscription type fail
      debugLog(e.toString());
      emit(NewsMarqueeState.error());
    }
  }
}
