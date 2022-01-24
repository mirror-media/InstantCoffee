import 'dart:async';
import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/services/categoryService.dart';
import 'package:readr_app/services/personalSubscriptionService.dart';

class PersonalPageBloc {
  LocalStorage _storage = LocalStorage('setting');
  CategoryService _categoryService = CategoryService();
  PersonalSubscriptionService _personalSubscriptionService = PersonalSubscriptionService();

  List<Category> _categoryList = [];
  List<Record> _recordList = [];
  List<Category> get categoryList => _categoryList;
  List<Record> get recordList => _recordList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _needLoadingMore = true;
  bool get needLoadingMore => _needLoadingMore;

  StreamController<ApiResponse<List<Category>>> _categoryController = 
      StreamController<ApiResponse<List<Category>>>();
  StreamSink<ApiResponse<List<Category>>> get categorySink =>
      _categoryController.sink;
  Stream<ApiResponse<List<Category>>> get categoryStream =>
      _categoryController.stream;

  StreamController<ApiResponse<List<Record>>> _personalSubscriptionController =
      StreamController<ApiResponse<List<Record>>>();
  StreamSink<ApiResponse<List<Record>>> get personalSubscriptionSink =>
      _personalSubscriptionController.sink;
  Stream<ApiResponse<List<Record>>> get personalSubscriptionStream =>
      _personalSubscriptionController.stream;

  PersonalPageBloc() {
    fetchCategoryListAndSubscriptionList();
  }

  categorySinkToAdd(ApiResponse<List<Category>> value) {
    if (!_categoryController.isClosed) {
      categorySink.add(value);
    }
  }

  personalSubscriptionSinkToAdd(ApiResponse<List<Record>> value) {
    if (!_personalSubscriptionController.isClosed) {
      personalSubscriptionSink.add(value);
    }
  }

  fetchCategoryListAndSubscriptionList() async {
    categorySinkToAdd(ApiResponse.loading('Fetching Category List'));

    try {
      List<Category>? localCategoryList;
      List<Category> onlineCategoryList = await _categoryService.fetchCategoryList();
      if (await _storage.ready) {
        if(_storage.getItem("categoryList") != null) {
          localCategoryList =
              Category.categoryListFromJson(_storage.getItem("categoryList"));
        }
      }

      List<Category> theNewestCategoryList = Category.getTheNewestCategoryList(
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

  fetchSubscriptionList(List<Category> categoryList, {int page = 1}) async {
    _isLoading = true;
    if (_recordList.length == 0) {
      personalSubscriptionSinkToAdd(
          ApiResponse.loading('Fetching Subscription Content'));
    } else {
      personalSubscriptionSinkToAdd(
          ApiResponse.loadingMore('Loading More Subscription Content'));
    }

    try {
      List<String> subscriptionIdStringList = Category.getSubscriptionIdStringList(categoryList);
      if(subscriptionIdStringList.length == 0) {
        _recordList.clear();
      } else {
        String categoryListJson = json.encode(subscriptionIdStringList);
        List<Record> latests = await _personalSubscriptionService.fetchRecordList(categoryListJson, page: page);
        _needLoadingMore = latests.length != 0;

        if (page == 1) {
          _recordList.clear();
        }

        latests = Record.filterDuplicatedSlugByAnother(latests, _recordList);
        _recordList.addAll(latests);
      }
      _isLoading = false;
      personalSubscriptionSinkToAdd(ApiResponse.completed(_recordList));
    } catch (e) {
      _isLoading = false;
      personalSubscriptionSinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  changeCategoryList(List<Category> categoryList) {
    categorySinkToAdd(ApiResponse.completed(categoryList));
  }

  setCategoryListInStorage(List<Category> categoryList) {
    _categoryList = categoryList;
    _storage.setItem("categoryList", Category.categoryListToJson(categoryList));
    changeCategoryList(categoryList);
    _recordList.clear();
    _personalSubscriptionService.initialPage();
    fetchSubscriptionList(categoryList);
  }

  loadingMore(int index) {
    if(_needLoadingMore && !_isLoading && index == _recordList.length - 5) {
      fetchSubscriptionList(_categoryList, page: _personalSubscriptionService.nextPage());
    }
  }

  dispose() {
    _categoryController.close();
    _personalSubscriptionController.close();
  }
}
