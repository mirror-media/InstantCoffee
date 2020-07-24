import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/recordService.dart';

class TabContentBloc {
  RecordList _records;
  String _endpoint = latestAPI;
  bool isLoading = false;
  String _loadmoreUrl = '';
  int _page = 1;

  RecordService _recordService;

  StreamController _recordListController;

  RecordList get records => _records;

  StreamSink<ApiResponse<RecordList>> get recordListSink =>
      _recordListController.sink;

  Stream<ApiResponse<RecordList>> get recordListStream =>
      _recordListController.stream;

  TabContentBloc(String id, String type) {
    _records = RecordList();
    _recordService = RecordService();
    _recordListController = StreamController<ApiResponse<RecordList>>();
    switchTab(id, type);
  }

  sinkToAdd(ApiResponse<RecordList> value) {
    if (!_recordListController.isClosed) {
      recordListSink.add(value);
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
      sinkToAdd(ApiResponse.completed(_records));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  refreshTheList(String id, String type) {
    _records.clear();
    _page = 1;
    switchTab(id, type);
  }

  switchTab(String id, String type) {
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

    fetchRecordList();
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
