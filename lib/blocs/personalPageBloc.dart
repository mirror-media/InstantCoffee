import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/categoryList.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/services/categoryService.dart';
import 'package:readr_app/services/personalSubscriptionService.dart';

class PersonalPageBloc {
  LocalStorage _storage;
  CategoryList _categoryList;
  RecordList _recordList;
  bool _isLoading = false;
  int _page = 1;

  bool get isLoading => _isLoading;
  CategoryList get categoryList => _categoryList;
  RecordList get recordList => _recordList;

  CategoryService _categoryService;
  PersonalSubscriptionService _personalSubscriptionService;

  StreamController _categoryController;

  StreamSink<ApiResponse<CategoryList>> get categorySink =>
      _categoryController.sink;
  Stream<ApiResponse<CategoryList>> get categoryStream =>
      _categoryController.stream;

  categorySinkToAdd(ApiResponse<CategoryList> value) {
    if (!_categoryController.isClosed) {
      categorySink.add(value);
    }
  }

  StreamController _personalSubscriptionController;

  StreamSink<ApiResponse<RecordList>> get personalSubscriptionSink =>
      _personalSubscriptionController.sink;
  Stream<ApiResponse<RecordList>> get personalSubscriptionStream =>
      _personalSubscriptionController.stream;

  personalSubscriptionSinkToAdd(ApiResponse<RecordList> value) {
    if (!_personalSubscriptionController.isClosed) {
      personalSubscriptionSink.add(value);
    }
  }

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

      CategoryList categoryList = CategoryList.getTheNewestCategoryList(
          localCategoryList: localCategoryList,
          onlineCategoryList: onlineCategoryList);
      _categoryList = categoryList;
      categorySinkToAdd(ApiResponse.completed(categoryList));

      fetchSubscriptionList(categoryList);
    } catch (e) {
      categorySinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchSubscriptionList(CategoryList categoryList) async {
    _isLoading = true;
    if (_recordList == null || _recordList.length == 0) {
      personalSubscriptionSinkToAdd(
          ApiResponse.loading('Fetching Subscription Content'));
    } else {
      personalSubscriptionSinkToAdd(
          ApiResponse.loadingMore('Loading More Subscription Content'));
    }

    try {
      RecordList latests = await _personalSubscriptionService.fetchRecordList(
          _page, categoryList);
      if (_page == 1) {
        _recordList.clear();
      }
      _page++;

      _recordList.addAll(latests);
      _isLoading = false;
      personalSubscriptionSinkToAdd(ApiResponse.completed(_recordList));
    } catch (e) {
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
    _page = 1;
    fetchSubscriptionList(categoryList);
  }

  loadingMore(ScrollController scrollController) {
    if (scrollController.hasClients) {
      print('hey');
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!_isLoading) {
          fetchSubscriptionList(_categoryList);
        }
      }
    }
  }

  dispose() {
    _categoryController?.close();
    _personalSubscriptionController?.close();
  }
}
