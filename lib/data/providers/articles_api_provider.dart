import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:readr_app/core/extensions/string_extension.dart';

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

  Future<List<TopicModel>?> getTopicTabList() async {
    String queryString = QueryDB.getTopicList.format([homePageTopicCount]);
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
}
