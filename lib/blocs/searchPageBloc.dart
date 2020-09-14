import 'dart:async';

import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/services/searchService.dart';
import 'package:readr_app/services/sectionService.dart';

class SearchPageBloc {
  /// get the section list data
  SectionService _sectionService;
  StreamController _sectionController;

  StreamSink<ApiResponse<SectionList>> get sectionSink =>
      _sectionController.sink;
  Stream<ApiResponse<SectionList>> get sectionStream =>
      _sectionController.stream;

  /// choose the target section data
  Section _initialTargetSection;
  Section get initialTargetSection => _initialTargetSection;
  StreamController _targetSectionController;

  StreamSink<Section> get targetSectionSink =>
      _targetSectionController.sink;
  Stream<Section> get targetSectionStream =>
      _targetSectionController.stream;

  /// searching data
  RecordList _searchList;
  RecordList get searchList => _searchList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  SearchService _searchService;
  StreamController _searchController;

  StreamSink<ApiResponse<RecordList>> get searchSink =>
      _searchController.sink;
  Stream<ApiResponse<RecordList>> get searchStream =>
      _searchController.stream;


  SearchPageBloc() {
    _sectionService = SectionService();
    _sectionController = StreamController<ApiResponse<SectionList>>();

    _initialTargetSection = Section(
      key: '',
      name: '',
      title: '全部類別',
      description: '',
      order: 0,
      type: 'fixed',
    );
    _targetSectionController = StreamController<Section>();

    _searchList = RecordList();
    _searchService = SearchService();
    _searchController = StreamController<ApiResponse<RecordList>>();

    fetchsectionList();
  }

  sectionSinkToAdd(ApiResponse<SectionList> value) {
    if (!_sectionController.isClosed) {
      sectionSink.add(value);
    }
  }

  targetSectionSinkToAdd(Section value) {
    if (!_targetSectionController.isClosed) {
      _initialTargetSection = value;
      targetSectionSink.add(value);
    }
  }

  searchSinkToAdd(ApiResponse<RecordList> value) {
    if (!_searchController.isClosed) {
      searchSink.add(value);
    }
  }

  fetchsectionList() async {
    sectionSinkToAdd(ApiResponse.loading('Fetching section List'));

    try {
      SectionList sectionList = await _sectionService.fetchSectionList(needMenu: false);
      sectionList.insert(
        0, 
        initialTargetSection,
      );
      sectionSinkToAdd(ApiResponse.completed(sectionList));
    } catch (e) {
      sectionSinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  search(String keyword, {int page = 1}) async {
    _isLoading = true;
    if(page == 1) {
      searchSinkToAdd(ApiResponse.loading('search $keyword in ${initialTargetSection.title} ($page page)'));
    } else {
      searchSinkToAdd(ApiResponse.loadingMore('search $keyword in ${initialTargetSection.title} ($page page)'));
    } 

    try {
      RecordList recordList = await _searchService.search(keyword, sectionId: initialTargetSection.key, page: _searchService.page);
      if(page == 1) {
        _searchService.initialPage();
        _searchList.clear();
      }

      recordList = recordList.filterDuplicatedSlugByAnother(_searchList);
      _searchList.addAll(recordList);
      _isLoading = false;
      searchSinkToAdd(ApiResponse.completed(_searchList));
    } catch (e) {
      _isLoading = false;
      searchSinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  loadingMore(String keyword, int index) {
    if(!_isLoading && index == _searchList.length - 5) {
      search(keyword, page: _searchService.nextPage());
    }
  }
  
  dispose() {
    _sectionController?.close();
    _targetSectionController?.close();
    _searchController?.close();
  }
}