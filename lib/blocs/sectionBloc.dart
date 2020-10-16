import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/services/sectionService.dart';

class SectionBloc {
  SectionService _sectionService;

  StreamController _sectionListController;

  StreamSink<ApiResponse<SectionList>> get sectionListSink =>
      _sectionListController.sink;

  Stream<ApiResponse<SectionList>> get sectionListStream =>
      _sectionListController.stream;

  SectionBloc() {
    _sectionService = SectionService();
    _sectionListController = StreamController<ApiResponse<SectionList>>();
    fetchSectionList();
  }

  sinkToAdd(ApiResponse<SectionList> value) {
    if (!_sectionListController.isClosed) {
      sectionListSink.add(value);
    }
  }

  fetchSectionList() async {
    sinkToAdd(ApiResponse.loading('Fetching Tab Content'));

    try {
      SectionList sectionList = await _sectionService.fetchSectionList();
      
      String sectionAdJsonFileLocation = Platform.isIOS
      ? 'assets/data/iOSSectionAd.json'
      : 'assets/data/androidSectionAd.json';
      // String sectionAdJsonFileLocation = Platform.isIOS
      // ? 'assets/data/iOSTestSectionAd.json'
      // : 'assets/data/androidTestSectionAd.json';
      String sectionAdString = await rootBundle.loadString(sectionAdJsonFileLocation);
      final sectionAdMaps = json.decode(sectionAdString);
      for(int i=0; i<sectionList.length; i++) {
        if(sectionAdMaps[sectionList[i].key] != null) {
          sectionList[i].sectionAd = SectionAd.fromJson(sectionAdMaps[sectionList[i].key]);
        } else {
          sectionList[i].sectionAd = SectionAd.fromJson(sectionAdMaps['other']);
        }
      }

      sinkToAdd(ApiResponse.completed(sectionList));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _sectionListController?.close();
  }
}
