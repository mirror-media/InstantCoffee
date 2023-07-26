import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:readr_app/core/extensions/string_extension.dart';

import 'package:readr_app/models/post/post.dart';

import '../../core/values/query.dart';
import '../../helpers/environment.dart';

class ArticlesApiProvider extends GetConnect {
  static const articleTakeCount = 12;
  ValueNotifier<GraphQLClient>? client;

  ArticlesApiProvider() {
    final Link link = HttpLink(Environment().config.graphqlApi);
    client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: link,
      ),
    );
  }

  /// 利用Topic id向 Was要求相關文章
  /// 如果要求失敗 回傳空List
  Future<List<Post>> getRelatedPostsByTopic(
      {required String topicId,
      int take = articleTakeCount,
      int skip = 0}) async {
    String queryString =
        QueryDB.fetchRelatedPostsByTopic.format([take, skip, topicId]);
    List<Post> postList = <Post>[];
    final result =
        await client?.value.query(QueryOptions(document: gql(queryString)));
    if (result == null || result.hasException) {
      return postList;
    }

    final Map<String, dynamic>? resultMap = result.data;
    if (resultMap == null || !resultMap.containsKey('posts')) return postList;

    for (var item in resultMap['posts']) {
      postList.add(Post.fromJson(item));
    }

    return postList;
  }
}
