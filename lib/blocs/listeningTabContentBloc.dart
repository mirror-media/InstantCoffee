import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/listeningTabContentService.dart';
import 'package:readr_app/models/recordList.dart';

class ListeningTabContentBloc {
  RecordList _records;

  String _endpoint = listeningWidgetApi;
  bool isLoading = false;
  String _loadmoreUrl = '';
  int _page = 1;

  ListeningTabContentService _listeningTabContentService;

  StreamController _listeningTabContentController;

  RecordList get records => _records;

  StreamSink<ApiResponse<RecordList>> get listeningTabContentSink => _listeningTabContentController.sink;

  Stream<ApiResponse<RecordList>> get listeningTabContentStream => _listeningTabContentController.stream;

  ListeningTabContentBloc() {
    _records = RecordList();
    _listeningTabContentService = ListeningTabContentService();
    _listeningTabContentController = StreamController<ApiResponse<RecordList>>();
    fetchRecordList();
  }

  sinkToAdd(ApiResponse<RecordList> value) {
    if (!_listeningTabContentController.isClosed) {
      listeningTabContentSink.add(value);
    }
  }

  fetchRecordList() async {
    isLoading = true;
    if (_records == null || _records.length == 0) {
      sinkToAdd(ApiResponse.loading('Fetching Listening Tab Content'));
    } else {
      sinkToAdd(ApiResponse.loadingMore('Loading More Listening Tab Content'));
    }

    try {
      RecordList latests = await _listeningTabContentService.fetchRecordList(_endpoint);
      _loadmoreUrl = _listeningTabContentService.getNext();
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

  refreshTheList() {
    _records.clear();
    _page = 1;
    _endpoint = listeningWidgetApi;
    fetchRecordList();
  }

  loadingMore(ScrollController scrollController) {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (_loadmoreUrl != '' && !isLoading) {
          _endpoint = _loadmoreUrl;
          fetchRecordList();
        }
      }
    }
  }
  
  dispose() {
    _listeningTabContentController?.close();
  }
}
