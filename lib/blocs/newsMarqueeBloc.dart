import 'dart:async';

import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/newsMarqueeService.dart';
import 'package:readr_app/models/recordList.dart';

class NewsMarqueeBloc {
  NewsMarqueeService _recordService;

  StreamController _recordListController;

  StreamSink<ApiResponse<RecordList>> get recordListSink =>
      _recordListController.sink;

  Stream<ApiResponse<RecordList>> get recordListStream =>
      _recordListController.stream;

  NewsMarqueeBloc() {
    _recordService = NewsMarqueeService();
    _recordListController = StreamController<ApiResponse<RecordList>>();
    fetchEditorChoiceList();
  }

  sinkToAdd(ApiResponse<RecordList> value) {
    if (!_recordListController.isClosed) {
      recordListSink.add(value);
    }
  }

  fetchEditorChoiceList() async {
    sinkToAdd(ApiResponse.loading('Fetching Tab Content'));

    try {
      RecordList records = await _recordService.fetchRecordList();

      sinkToAdd(ApiResponse.completed(records));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _recordListController?.close();
  }
}
