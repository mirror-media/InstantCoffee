import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/listingTabContentService.dart';
import 'package:readr_app/models/recordList.dart';

class ListingTabContentBloc {
  RecordList _records;

  String _endpoint = listingPageApi;
  bool isLoading = false;
  String _loadmoreUrl = '';
  int _page = 1;

  ListingTabContentService _listingTabContentService;

  StreamController _listingTabContentController;

  RecordList get records => _records;

  StreamSink<ApiResponse<RecordList>> get listingTabContentSink => _listingTabContentController.sink;

  Stream<ApiResponse<RecordList>> get listingTabContentStream => _listingTabContentController.stream;

  ListingTabContentBloc() {
    _records = RecordList();
    _listingTabContentService = ListingTabContentService();
    _listingTabContentController = StreamController<ApiResponse<RecordList>>();
    fetchRecordList();
  }

  sinkToAdd(ApiResponse<RecordList> value) {
    if (!_listingTabContentController.isClosed) {
      listingTabContentSink.add(value);
    }
  }

  fetchRecordList() async {
    isLoading = true;
    if (_records == null || _records.length == 0) {
      sinkToAdd(ApiResponse.loading('Fetching Listing Tab Content'));
    } else {
      sinkToAdd(ApiResponse.loadingMore('Loading More Listing Tab Content'));
    }

    try {
      RecordList latests = await _listingTabContentService.fetchRecordList(_endpoint);
      _loadmoreUrl = _listingTabContentService.getNext();
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
    _endpoint = listingPageApi;
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
    _listingTabContentController?.close();
  }
}
