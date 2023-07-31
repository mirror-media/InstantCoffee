import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/models/article_info/article_info.dart';
import 'package:readr_app/models/post/post_model.dart';

import '../../core/values/query.dart';
import '../../helpers/environment.dart';
import '../../models/topic/topic_model.dart';

class ArticlesApiProvider extends GetConnect {
  ArticlesApiProvider._();

  static final ArticlesApiProvider _instance = ArticlesApiProvider._();

  static ArticlesApiProvider get instance => _instance;

  static const articleTakeCount = 12;
  static const homePageTopicCount = 5;
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
    String queryString = QueryDB.getTopicList.format([take, skip]);
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

  Future<ArticleInfo?> getArticleInfoBySlug({required String slug })async{
    String queryString =QueryDB.getArticleInfoBySlug.format([slug]);
    final result =
      await client?.value.query(QueryOptions(document: gql(queryString)));
    if(result == null ||  result.data ==null) return null;
    if(!result.data!.containsKey('post')) return null;
    return ArticleInfo.fromJson(result.data!['post']);
  }

}
