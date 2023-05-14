import 'dart:async';

import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_response.dart';
import 'package:readr_app/models/section_ad.dart';
import 'package:readr_app/services/listening_tab_content_service.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/logger.dart';

class ListeningTabContentBloc with Logger {
  String _endpoint = Environment().config.listeningWidgetApi;
  bool _isLoading = false;
  bool _needLoadingMore = true;

  final ListeningTabContentService _listeningTabContentService =
      ListeningTabContentService();

  late SectionAd _sectionAd;
  final List<Record> _records = [];
  SectionAd get sectionAd => _sectionAd;
  List<Record> get records => _records;

  final StreamController<ApiResponse<List<Record>>>
      _listeningTabContentController =
      StreamController<ApiResponse<List<Record>>>();
  StreamSink<ApiResponse<List<Record>>> get listeningTabContentSink =>
      _listeningTabContentController.sink;
  Stream<ApiResponse<List<Record>>> get listeningTabContentStream =>
      _listeningTabContentController.stream;

  ListeningTabContentBloc(SectionAd sectionAd) {
    _sectionAd = sectionAd;
    fetchRecordList();
  }

  sinkToAdd(ApiResponse<List<Record>> value) {
    if (!_listeningTabContentController.isClosed) {
      listeningTabContentSink.add(value);
    }
  }

  fetchRecordList() async {
    _isLoading = true;
    if (_records.isEmpty) {
      sinkToAdd(ApiResponse.loading('Fetching Listening Tab Content'));
    } else {
      sinkToAdd(ApiResponse.loadingMore('Loading More Listening Tab Content'));
    }

    try {
      List<Record> latests =
          await _listeningTabContentService.fetchRecordList(_endpoint);
      _needLoadingMore = latests.isNotEmpty;

      if (_listeningTabContentService.page == 1) {
        _records.clear();
      }

      latests = Record.filterDuplicatedSlugByAnother(latests, _records);
      _records.addAll(latests);
      _isLoading = false;
      sinkToAdd(ApiResponse.completed(_records));
    } catch (e) {
      _isLoading = false;
      sinkToAdd(ApiResponse.error(e.toString()));
      debugLog(e);
    }
  }

  refreshTheList() {
    _records.clear();
    _listeningTabContentService.initialPage();
    _endpoint = Environment().config.listeningWidgetApi;
    fetchRecordList();
  }

  loadingMore(int index) {
    if (_needLoadingMore && !_isLoading && index == _records.length - 5) {
      _listeningTabContentService.nextPage();
      _endpoint = _listeningTabContentService.getNextUrl;
      fetchRecordList();
    }
  }

  dispose() {
    _listeningTabContentController.close();
  }
}
