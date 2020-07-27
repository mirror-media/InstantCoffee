import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/editorChoiceService.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/recordService.dart';

class TabContentBloc {
  RecordList _records;
  RecordList _editorChoices;

  String _endpoint = latestAPI;
  bool isLoading = false;
  String _loadmoreUrl = '';
  int _page = 1;

  RecordService _recordService;
  EditorChoiceService _editorChoiceService;

  StreamController _recordListController;

  RecordList get records => _records;
  RecordList get editorChoices => _editorChoices;

  StreamSink<ApiResponse<TabContentState>> get recordListSink =>
      _recordListController.sink;

  Stream<ApiResponse<TabContentState>> get recordListStream =>
      _recordListController.stream;

  TabContentBloc(String id, String type, bool needCarousel) {
    _records = RecordList();
    _recordService = RecordService();

    if(needCarousel) {
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
      _records.addAll(latests);

      _loadmoreUrl = _recordService.getNext();
      _page++;
    
      sinkToAdd(ApiResponse.completed(TabContentState(editorChoiceList: _editorChoices, recordList: _records)));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchRecordList() async {
    isLoading = true;
    if (_records == null || _records.length == 0) {
      sinkToAdd(ApiResponse.loading('Fetching Tab Content'));
    } else {
      sinkToAdd(ApiResponse.loadingMore('Loading More Tab Content'));
    }

    try {
      RecordList latests = await _recordService.fetchRecordList(_endpoint);
      _loadmoreUrl = _recordService.getNext();
      if (_page == 1) {
        _records.clear();
      }
      _page++;

      _records.addAll(latests);
      isLoading = false;
      sinkToAdd(ApiResponse.completed(TabContentState(editorChoiceList: _editorChoices, recordList: _records)));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  refreshTheList(String id, String type, bool needCarousel) {
    _records.clear();
    _page = 1;
    switchTab(id, type, needCarousel: needCarousel);
  }

  switchTab(String id, String type, {bool needCarousel = false}) {
    _page = 1;
    if (type == 'section') {
      _endpoint = listingBase + '&where={"sections":{"\$in":["' + id + '"]}}';
    } else if (id == 'latest') {
      _endpoint = latestAPI;
    } else if (id == 'popular') {
      _endpoint = popularListAPI;
    } else if (id == 'personal') {
      _endpoint = listingBaseSearchByPersonAndFoodSection;
    }

    if(needCarousel) {
      fetchEditorChoiceAndRecordList();
    }
    else {
      fetchRecordList();
    }
  }

  loadingMore(ScrollController scrollController) {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (_loadmoreUrl != '' && !isLoading) {
          _endpoint = apiBase + _loadmoreUrl;
          fetchRecordList();
        }
      }
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
