import 'dart:async';

import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/services/newsMarqueeService.dart';
import 'package:readr_app/models/record.dart';

class NewsMarqueeBloc {
  NewsMarqueeService _recordService = NewsMarqueeService();

  StreamController<ApiResponse<List<Record>>> _recordListController = StreamController<ApiResponse<List<Record>>>();
  StreamSink<ApiResponse<List<Record>>> get recordListSink =>
      _recordListController.sink;
  Stream<ApiResponse<List<Record>>> get recordListStream =>
      _recordListController.stream;

  NewsMarqueeBloc() {
    fetchEditorChoiceList();
  }

  sinkToAdd(ApiResponse<List<Record>> value) {
    if (!_recordListController.isClosed) {
      recordListSink.add(value);
    }
  }

  fetchEditorChoiceList() async {
    sinkToAdd(ApiResponse.loading('Fetching Tab Content'));

    try {
      List<Record> records = await _recordService.fetchRecordList();

      sinkToAdd(ApiResponse.completed(records));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _recordListController.close();
  }
}
