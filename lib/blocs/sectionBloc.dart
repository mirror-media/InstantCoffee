import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/services/sectionService.dart';

class SectionBloc {
  SectionService _sectionService = SectionService();

  StreamController<ApiResponse<List<Section>>> _sectionListController = StreamController<ApiResponse<List<Section>>>();
  StreamSink<ApiResponse<List<Section>>> get sectionListSink =>
      _sectionListController.sink;
  Stream<ApiResponse<List<Section>>> get sectionListStream =>
      _sectionListController.stream;

  SectionBloc() {
    fetchSectionList();
  }

  sinkToAdd(ApiResponse<List<Section>> value) {
    if (!_sectionListController.isClosed) {
      sectionListSink.add(value);
    }
  }

  fetchSectionList() async {
    sinkToAdd(ApiResponse.loading('Fetching Tab Content'));

    try {
      List<Section> sectionList = await _sectionService.fetchSectionList();
      
      String sectionAdJsonFileLocation = Platform.isIOS
      ? Environment().config.iOSSectionAdJsonLocation
      : Environment().config.androidSectionAdJsonLocation;
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
    _sectionListController.close();
  }
}
