import 'package:readr_app/models/category.dart';

abstract class PersonalArticleEvents{}

class FetchSubscribedArticleList extends PersonalArticleEvents {
  final List<Category> subscribedCategoryList;
  FetchSubscribedArticleList(
    this.subscribedCategoryList
  );

  @override
  String toString() => 'FetchSubscribedArticleList';
}

class FetchNextPageSubscribedArticleList extends PersonalArticleEvents {
  final List<Category> subscribedCategoryList;
  FetchNextPageSubscribedArticleList(
    this.subscribedCategoryList
  );

  @override
  String toString() => 'FetchNextPageSubscribedArticleList';
}