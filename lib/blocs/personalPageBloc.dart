import 'dart:async';

import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/categoryList.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/services/categoryService.dart';
import 'package:readr_app/services/personalSubscriptionService.dart';

class PersonalPageBloc {
  LocalStorage _storage;
  CategoryService _categoryService;
  PersonalSubscriptionService _personalSubscriptionService;

  CategoryList _categoryList;
  RecordList _recordList;
  CategoryList get categoryList => _categoryList;
  RecordList get recordList => _recordList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamController _categoryController;
  StreamSink<ApiResponse<CategoryList>> get categorySink =>
      _categoryController.sink;
  Stream<ApiResponse<CategoryList>> get categoryStream =>
      _categoryController.stream;

  StreamController _personalSubscriptionController;
  StreamSink<ApiResponse<RecordList>> get personalSubscriptionSink =>
      _personalSubscriptionController.sink;
  Stream<ApiResponse<RecordList>> get personalSubscriptionStream =>
      _personalSubscriptionController.stream;

  PersonalPageBloc() {
    _storage = LocalStorage('setting');
    _categoryList = CategoryList();
    _recordList = RecordList();

    _categoryService = CategoryService();
    _personalSubscriptionService = PersonalSubscriptionService();
    _categoryController = StreamController<ApiResponse<CategoryList>>();
    _personalSubscriptionController =
        StreamController<ApiResponse<RecordList>>();

    fetchCategoryListAndSubscriptionList();
  }

  categorySinkToAdd(ApiResponse<CategoryList> value) {
    if (!_categoryController.isClosed) {
      categorySink.add(value);
    }
  }

  personalSubscriptionSinkToAdd(ApiResponse<RecordList> value) {
    if (!_personalSubscriptionController.isClosed) {
      personalSubscriptionSink.add(value);
    }
  }

  fetchCategoryListAndSubscriptionList() async {
    categorySinkToAdd(ApiResponse.loading('Fetching Category List'));

    try {
      CategoryList localCategoryList;
      CategoryList onlineCategoryList;
      if (await _storage.ready) {
        localCategoryList =
            CategoryList.fromJson(_storage.getItem("categoryList"));
      }

      onlineCategoryList = await _categoryService.fetchCategoryList();

      CategoryList theNewestCategoryList = CategoryList.getTheNewestCategoryList(
          localCategoryList: localCategoryList,
          onlineCategoryList: onlineCategoryList);
      _categoryList = theNewestCategoryList;
      categorySinkToAdd(ApiResponse.completed(_categoryList));

      fetchSubscriptionList(_categoryList);
    } catch (e) {
      categorySinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchSubscriptionList(CategoryList categoryList, {int page = 1}) async {
    _isLoading = true;
    if (_recordList == null || _recordList.length == 0) {
      personalSubscriptionSinkToAdd(
          ApiResponse.loading('Fetching Subscription Content'));
    } else {
      personalSubscriptionSinkToAdd(
          ApiResponse.loadingMore('Loading More Subscription Content'));
    }

    try {
      RecordList latests = await _personalSubscriptionService.fetchRecordList(categoryList, page: page);
      if (page == 1) {
        _recordList.clear();
      }

      latests = latests.filterDuplicatedSlugByAnother(_recordList);
      _recordList.addAll(latests);
      _isLoading = false;
      personalSubscriptionSinkToAdd(ApiResponse.completed(_recordList));
    } catch (e) {
      _isLoading = false;
      personalSubscriptionSinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  changeCategoryList(CategoryList categoryList) {
    categorySinkToAdd(ApiResponse.completed(categoryList));
  }

  setCategoryListInStorage(CategoryList categoryList) {
    _categoryList = categoryList;
    _storage.setItem("categoryList", categoryList.toJson());
    changeCategoryList(categoryList);
    _recordList.clear();
    _personalSubscriptionService.initialPage();
    fetchSubscriptionList(categoryList);
  }

  loadingMore(int index) {
    if(!_isLoading && index == _recordList.length - 5) {
      fetchSubscriptionList(_categoryList, page: _personalSubscriptionService.nextPage());
    }
  }

  dispose() {
    _categoryController?.close();
    _personalSubscriptionController?.close();
  }
}
