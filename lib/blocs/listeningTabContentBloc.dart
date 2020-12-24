import 'dart:async';

import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/services/listeningTabContentService.dart';
import 'package:readr_app/models/recordList.dart';

class ListeningTabContentBloc {
  String _endpoint = env.baseConfig.listeningWidgetApi;
  bool _isLoading = false;
  
  ListeningTabContentService _listeningTabContentService;

  SectionAd _sectionAd;
  RecordList _records;
  SectionAd get sectionAd => _sectionAd;
  RecordList get records => _records;

  StreamController _listeningTabContentController;
  StreamSink<ApiResponse<RecordList>> get listeningTabContentSink =>
      _listeningTabContentController.sink;
  Stream<ApiResponse<RecordList>> get listeningTabContentStream =>
      _listeningTabContentController.stream;

  ListeningTabContentBloc(SectionAd sectionAd) {
    _sectionAd = sectionAd;
    _records = RecordList();
    _listeningTabContentService = ListeningTabContentService();
    _listeningTabContentController =
        StreamController<ApiResponse<RecordList>>();
    fetchRecordList();
  }

  sinkToAdd(ApiResponse<RecordList> value) {
    if (!_listeningTabContentController.isClosed) {
      listeningTabContentSink.add(value);
    }
  }

  fetchRecordList() async {
    _isLoading = true;
    if (_records == null || _records.length == 0) {
      sinkToAdd(ApiResponse.loading('Fetching Listening Tab Content'));
    } else {
      sinkToAdd(ApiResponse.loadingMore('Loading More Listening Tab Content'));
    }

    try {
      RecordList latests =
          await _listeningTabContentService.fetchRecordList(_endpoint);
      
      if (_listeningTabContentService.page == 1) {
        _records.clear();
      }

      latests = latests.filterDuplicatedSlugByAnother(_records);
      _records.addAll(latests);
      _isLoading = false;
      sinkToAdd(ApiResponse.completed(_records));
    } catch (e) {
      _isLoading = false;
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  refreshTheList() {
    _records.clear();
    _listeningTabContentService.initialPage();
    _endpoint = env.baseConfig.listeningWidgetApi;
    fetchRecordList();
  }

  loadingMore(int index) {
    if(!_isLoading && index == _records.length - 5) {
      _listeningTabContentService.nextPage();
      _endpoint = _listeningTabContentService.getNextUrl;
      fetchRecordList();
    }
  }

  dispose() {
    _listeningTabContentController?.close();
  }
}
