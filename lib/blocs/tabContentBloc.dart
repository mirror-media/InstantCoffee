import 'dart:async';

import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/recordService.dart';

class TabContentBloc {
  String _endpoint = Environment().config.latestApi;
  bool _isLoading = false;
  
  RecordService _recordService = RecordService();

  SectionAd? _sectionAd;
  List<Record> _records = [];
  SectionAd? get sectionAd => _sectionAd;
  List<Record> get records => _records;

  StreamController<ApiResponse<TabContentState>> _recordListController = 
      StreamController<ApiResponse<TabContentState>>();
  StreamSink<ApiResponse<TabContentState>> get recordListSink =>
      _recordListController.sink;
  Stream<ApiResponse<TabContentState>> get recordListStream =>
      _recordListController.stream;

  TabContentBloc(SectionAd? sectionAd, String id, String type) {
    _sectionAd = sectionAd;
    switchTab(id, type);
  }

  sinkToAdd(ApiResponse<TabContentState> value) {
    if (!_recordListController.isClosed) {
      recordListSink.add(value);
    }
  }

  fetchRecordList() async {
    _isLoading = true;
    if (_records.length == 0) {
      sinkToAdd(ApiResponse.loading('Fetching Tab Content'));
    } else {
      sinkToAdd(ApiResponse.loadingMore('Loading More Tab Content'));
    }

    try {
      List<Record> latests = await _recordService.fetchRecordList(_endpoint);
      if (_recordService.page == 1) {
        _records.clear();
      }

      latests = Record.filterDuplicatedSlugByAnother(latests, _records);
      _records.addAll(latests);
      _isLoading = false;
      sinkToAdd(ApiResponse.completed(TabContentState(recordList: _records)));
    } catch (e) {
      _isLoading = false;
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  refreshTheList(String id, String type) {
    _records.clear();
    _recordService.initialPage();
    switchTab(id, type);
  }

  switchTab(String id, String type) {
    _recordService.initialPage();
    if (type == 'section') {
      _endpoint = Environment().config.listingBase + '&where={"sections":{"\$in":["' + id + '"]}}';
    } else if (id == 'latest') {
      _endpoint = Environment().config.latestApi;
    } else if (id == 'popular') {
      _endpoint = Environment().config.popularListApi;
    } else if (id == 'personal') {
      _endpoint = Environment().config.listingBaseSearchByPersonAndFoodSection;
    }

    fetchRecordList();
  }

  loadingMore(int index) {
    if(!_isLoading && _recordService.getNextUrl != '' && index == _records.length - 5) {
      _recordService.nextPage();
      _endpoint = _recordService.getNextUrl;
      fetchRecordList();
    }
  }

  dispose() {
    _recordListController.close();
  }
}

class TabContentState {
  final List<Record> recordList;

  TabContentState({
    required this.recordList,
  });
}
