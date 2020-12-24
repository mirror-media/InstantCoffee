import 'dart:async';

import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/services/editorChoiceService.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/services/recordService.dart';

class TabContentBloc {
  String _endpoint = env.baseConfig.latestAPI;
  bool _isLoading = false;
  
  RecordService _recordService;
  EditorChoiceService _editorChoiceService;

  SectionAd _sectionAd;
  RecordList _records;
  RecordList _editorChoices;
  SectionAd get sectionAd => _sectionAd;
  RecordList get records => _records;
  RecordList get editorChoices => _editorChoices;

  StreamController _recordListController;
  StreamSink<ApiResponse<TabContentState>> get recordListSink =>
      _recordListController.sink;
  Stream<ApiResponse<TabContentState>> get recordListStream =>
      _recordListController.stream;

  TabContentBloc(SectionAd sectionAd, String id, String type, bool needCarousel) {
    _sectionAd = sectionAd;
    _records = RecordList();
    _recordService = RecordService();

    if (needCarousel) {
      _editorChoices = RecordList();
      _editorChoiceService = EditorChoiceService();
    }

    _recordListController = StreamController<ApiResponse<TabContentState>>();
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
      RecordList editorChoices = await _editorChoiceService.fetchRecordList();
      RecordList latests = await _recordService.fetchRecordList(_endpoint);
      _editorChoices.addAll(editorChoices);
      latests = latests.filterDuplicatedSlugByAnother(_records);
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
    if (_records == null || _records.length == 0) {
      sinkToAdd(ApiResponse.loading('Fetching Tab Content'));
    } else {
      sinkToAdd(ApiResponse.loadingMore('Loading More Tab Content'));
    }

    try {
      RecordList latests = await _recordService.fetchRecordList(_endpoint);
      if (_recordService.page == 1) {
        _records.clear();
      }

      latests = latests.filterDuplicatedSlugByAnother(_records);
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
      _endpoint = env.baseConfig.listingBase + '&where={"sections":{"\$in":["' + id + '"]}}';
    } else if (id == 'latest') {
      _endpoint = env.baseConfig.latestAPI;
    } else if (id == 'popular') {
      _endpoint = env.baseConfig.popularListAPI;
    } else if (id == 'personal') {
      _endpoint = env.baseConfig.listingBaseSearchByPersonAndFoodSection;
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
    _recordListController?.close();
  }
}

class TabContentState {
  final RecordList editorChoiceList;
  final RecordList recordList;

  TabContentState({
    this.editorChoiceList,
    this.recordList,
  });
}
