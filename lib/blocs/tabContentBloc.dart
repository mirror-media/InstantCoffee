import 'dart:async';

import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/services/editorChoiceService.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/recordService.dart';

class TabContentBloc {
  String _endpoint = Environment().config.latestApi;
  bool _isLoading = false;
  
  RecordService _recordService = RecordService();
  EditorChoiceService? _editorChoiceService;

  late SectionAd _sectionAd;
  List<Record> _records = [];
  List<Record>? _editorChoices;
  SectionAd get sectionAd => _sectionAd;
  List<Record> get records => _records;
  List<Record>? get editorChoices => _editorChoices;

  StreamController<ApiResponse<TabContentState>> _recordListController = 
      StreamController<ApiResponse<TabContentState>>();
  StreamSink<ApiResponse<TabContentState>> get recordListSink =>
      _recordListController.sink;
  Stream<ApiResponse<TabContentState>> get recordListStream =>
      _recordListController.stream;

  TabContentBloc(SectionAd sectionAd, String id, String type, bool needCarousel) {
    _sectionAd = sectionAd;

    if (needCarousel) {
      _editorChoices = [];
      _editorChoiceService = EditorChoiceService();
    }

    switchTab(id, type, needCarousel: needCarousel);
  }

  sinkToAdd(ApiResponse<TabContentState> value) {
    if (!_recordListController.isClosed) {
      recordListSink.add(value);
    }
  }

  fetchEditorChoiceAndRecordList() async {
    sinkToAdd(ApiResponse.loading('Fetching Tab Content'));

    try {
      List<Record> editorChoices = await _editorChoiceService!.fetchRecordList();
      List<Record> latests = await _recordService.fetchRecordList(_endpoint);
      _editorChoices!.addAll(editorChoices);
      latests = Record.filterDuplicatedSlugByAnother(latests, _records);
      _records.addAll(latests);

      sinkToAdd(ApiResponse.completed(TabContentState(
          editorChoiceList: _editorChoices, recordList: _records)));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
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
      sinkToAdd(ApiResponse.completed(TabContentState(
          editorChoiceList: _editorChoices, recordList: _records)));
    } catch (e) {
      _isLoading = false;
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  refreshTheList(String id, String type, bool needCarousel) {
    _records.clear();
    _recordService.initialPage();
    switchTab(id, type, needCarousel: needCarousel);
  }

  switchTab(String id, String type, {bool needCarousel = false}) {
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

    if (needCarousel) {
      fetchEditorChoiceAndRecordList();
    } else {
      fetchRecordList();
    }
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
  final List<Record>? editorChoiceList;
  final List<Record> recordList;

  TabContentState({
    this.editorChoiceList,
    required this.recordList,
  });
}
