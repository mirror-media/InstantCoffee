import 'package:readr_app/models/category.dart';

abstract class PersonalCategoryEvents{}

class FetchSubscribedCategoryList extends PersonalCategoryEvents {
  @override
  String toString() => 'FetchSubscribedCategoryList';
}

class SetCategoryListInStorage extends PersonalCategoryEvents {
  final List<Category> categoryList;
  SetCategoryListInStorage(
    this.categoryList
  );

  @override
  String toString() => 'SetCategoryListInStorage';
}