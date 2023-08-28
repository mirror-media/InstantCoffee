import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/models/external_story.dart';
import 'package:readr_app/models/magazine_list.dart';
import 'package:readr_app/models/post/post_model.dart';
import 'package:readr_app/models/story_res.dart';

import '../../core/values/query.dart';
import '../../helpers/environment.dart';
import '../../models/category.dart';
import '../../models/record.dart';
import '../../models/record_list_and_all_count.dart';
import '../../models/section.dart';
import '../../models/topic/topic_model.dart';

class ArticlesApiProvider extends GetConnect {
  ArticlesApiProvider._();

  static final ArticlesApiProvider _instance = ArticlesApiProvider._();

  static ArticlesApiProvider get instance => _instance;

  static const articleTakeCount = 12;
  static const homePageTopicCount = 5;
  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  ValueNotifier<GraphQLClient>? client;

  @override
  void onInit() {
    final Link link = HttpLink(Environment().config.graphqlApi);
    client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: link,
      ),
    );
  }

  /// 首頁獲得Topic按鈕資訊 預設為5個
  Future<List<TopicModel>?> getTopicTabList(
      {int take = homePageTopicCount, int skip = 0}) async {
    String queryString = QueryDB.fetchTopicList.format([take, skip]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    List<TopicModel> topicList = <TopicModel>[];
    if (result == null || result.hasException) {
      return topicList;
    }

    final Map<String, dynamic>? resultMap = result.data;
    if (resultMap == null || !resultMap.containsKey('topics')) return topicList;
    for (var item in resultMap['topics']) {
      topicList.add(TopicModel.fromJson(item));
    }
    return topicList;
  }

  /// 利用Topic id向 Was要求相關文章
  /// 如果要求失敗 回傳空List
  Future<List<PostModel>> getRelatedPostsByTopic(
      {required String topicId,
      int take = articleTakeCount,
      int skip = 0}) async {
    String queryString =
        QueryDB.fetchRelatedPostsByTopic.format([take, skip, topicId]);
    List<PostModel> postList = <PostModel>[];
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    if (result == null || result.hasException) {
      return postList;
    }

    final Map<String, dynamic>? resultMap = result.data;
    if (resultMap == null || !resultMap.containsKey('posts')) return postList;

    for (var item in resultMap['posts']) {
      postList.add(PostModel.fromJson(item));
    }
    return postList;
  }

  /// 依照規格已經完成 但現有的app 好像沒有使用此app
  /// 另外傳回的是相對路徑,因此還需要再加上root路徑
  /// 傳回範例：/images/20161003190629-c438d73ee83efeafa8746fa33216253c.jpg
  Future<List<String>> getRelatedImagesUrlByTopicId() async {
    String queryString = QueryDB.fetchRelatedImageByTopic.format([122]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    List<String> urlList = [];
    if (result == null || result.data == null) return urlList;
    if (!result.data!.containsKey('photos')) return urlList;
    final photosList = result.data!['photos'];
    for (final photo in photosList) {
      final Map<String, dynamic> photoInfo = photo;
      if (photoInfo.containsKey('imageFile')) {
        final Map<String, dynamic> imageFile = photoInfo['imageFile'];
        if (imageFile.containsKey('url')) {
          urlList.add(imageFile['url']);
        }
      }
    }
    return urlList;
  }

  Future<StoryRes?> getArticleInfoBySlug({required String slug}) async {
    String queryString = QueryDB.fetchArticleInfoBySlug.format([slug]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    if (result == null || result.data == null) return null;
    if (!result.data!.containsKey('post')) return null;
    return StoryRes.fromJsonK6(result.data!['post']);
  }

  Future<List<Record>> getHomePageChoiceArticle() async {
    final result = await apiBaseHelper
        .getByUrl('${Environment().config.latestApi}post_external01.json');

    return (result['choices'] as List<dynamic>)
        .map((e) => Record.fromJson(e))
        .toList();
  }

  Future<List<Record>> getHomePageLatestArticleList({int page = 1}) async {
    final result = await apiBaseHelper
        .getByUrl('${Environment().config.latestApi}post_external0$page.json');

    return (result['latest'] as List<dynamic>)
        .map((e) => Record.fromJson(e))
        .toList();
  }

  Future<List<Record>> getPopularArticleList() async {
    final result =
        await apiBaseHelper.getByUrl(Environment().config.popularListApi);

    final resultList = result as List<dynamic>;
    List<Record> articleList = [];
    for (final result in resultList) {
      if (result != null) {
        articleList.add(Record.fromJsonK6(result));
      }
    }
    return articleList;
  }

  Future<List<Record>> getArticleListBySection(
      {required String section, int page = 0}) async {
    String queryString =
        QueryDB.fetchArticleListBySection.format([page * 12, section]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    List<Record> articleList = [];
    if (result == null ||
        result.data == null ||
        !result.data!.containsKey('posts')) return articleList;
    final postList = result.data!['posts'];
    for (final post in postList) {
      if (post != null) {
        articleList.add(Record.fromJsonK6(post));
      }
    }
    return articleList;
  }

  Future<List<Section>> getSectionList() async {
    String queryString = QueryDB.fetchSectionList;
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    List<Section> sectionList = [];
    if (result == null ||
        result.data == null ||
        !result.data!.containsKey('sections')) return sectionList;
    final resultList = result.data!['sections'] as List<dynamic>;
    sectionList =
        resultList.map((element) => Section.fromJsonK6(element)).toList();
    return sectionList;
  }

  Future<List<Category>> getCategoriesList() async {
    String queryString = QueryDB.fetchCategoriesList;
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    List<Category> categoryList = [];
    if (result == null ||
        result.data == null ||
        !result.data!.containsKey('categories')) return categoryList;
    final list = result.data!['categories'] as List<dynamic>;
    categoryList
        .addAll(list.map((element) => Category.fromJson(element)).toList());
    return categoryList;
  }

  Future<List<Record>> getArticleListByCategoryList(
      {required List<Category> list, int page = 0}) async {
    if (list.isEmpty) return [];
    String queryString = QueryDB.fetchArticleListByCategoryList
        .format([page, list.toFormattedString()]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    List<Record> articleList = [];
    if (result == null ||
        result.data == null ||
        !result.data!.containsKey('posts')) return articleList;
    final postList = result.data!['posts'];
    for (final post in postList) {
      if (post != null) {
        articleList.add(Record.fromJsonK6(post));
      }
    }
    return articleList;
  }

  Future<RecordListAndAllCount> getArticleListByTag(
      {required String tag, int page = 1}) async {
    String queryString = QueryDB.fetchArticleListByTags.format([page, tag]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    List<Record> articleList = [];
    if (result == null ||
        result.data == null ||
        !result.data!.containsKey('posts')) {
      return RecordListAndAllCount(
          recordList: articleList, allCount: articleList.length);
    }
    final postList = result.data!['posts'];
    for (final post in postList) {
      if (post != null) {
        articleList.add(Record.fromJsonK6(post));
      }
    }
    return RecordListAndAllCount(
        recordList: articleList, allCount: articleList.length);
  }

  Future<ExternalStory> getExternalArticleBySlug({required String slug}) async {
    String queryString = QueryDB.getExternalArticleBySlug.format([slug]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    if (result == null ||
        result.data == null ||
        !result.data!.containsKey('external')) return ExternalStory();
    return ExternalStory.fromJsonK6(result.data!['external']);
  }

  Future<MagazineList> getMagazinesList(String type, {int page = 1}) async {
    String queryString = QueryDB.getMagazinesList.format([page]);
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    if (result == null ||
        result.data == null ||
        !result.data!.containsKey('magazines')) return MagazineList();

    return MagazineList.fromJson(result.data!['magazines'], type, isK6: true);
  }

  Future<List<Record>> getNewsletterList() async {
    final result = await apiBaseHelper
            .getByUrl('${Environment().config.latestApi}header_posts.json')
        as Map<String, dynamic>;
    List<Record> articlesList = [];
    if (!result.containsKey('posts') || result['posts'] is! List<dynamic>) {
      return articlesList;
    }
    final postsList = result['posts'] as List<dynamic>;
    return postsList.map((e) => Record.fromJsonK6(e)).toList();
  }
}
