import 'dart:async';

import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/listeningTabContentService.dart';
import 'package:readr_app/models/listeningWidgetService.dart';
import 'package:readr_app/models/recordList.dart';

class ListeningWidgetBloc {
  ListeningWidgetService _listeningWidgetService;
  ListeningTabContentService _listeningTabContentService;

  StreamController _listeningWidgetController;

  StreamSink<ApiResponse<TabContentState>> get listeningWidgetSink =>
      _listeningWidgetController.sink;

  Stream<ApiResponse<TabContentState>> get listeningWidgetStream =>
      _listeningWidgetController.stream;

  ListeningWidgetBloc(String slug) {
    _listeningWidgetService = ListeningWidgetService();
    _listeningTabContentService = ListeningTabContentService();
    _listeningWidgetController =
        StreamController<ApiResponse<TabContentState>>();
    fetchListening(slug);
  }

  sinkToAdd(ApiResponse<TabContentState> value) {
    if (!_listeningWidgetController.isClosed) {
      listeningWidgetSink.add(value);
    }
  }

  fetchListening(String slug) async {
    sinkToAdd(ApiResponse.loading('Fetching listeningWidget page'));

    try {
      Listening listening = await _listeningWidgetService.fetchListening(slug);
      RecordList recordList = await _listeningTabContentService.fetchRecordList(
          apiBase +
              'youtube/search?maxResults=7&order=date&part=snippet&channelId=UCYkldEK001GxR884OZMFnRw');

      sinkToAdd(ApiResponse.completed(
          TabContentState(listening: listening, recordList: recordList)));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _listeningWidgetController?.close();
  }
}

class TabContentState {
  final Listening listening;
  final RecordList recordList;

  TabContentState({
    this.listening,
    this.recordList,
  });
}
