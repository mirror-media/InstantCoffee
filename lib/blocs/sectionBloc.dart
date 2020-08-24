import 'dart:async';

import 'package:readr_app/helpers/apiResponse.dart';
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
