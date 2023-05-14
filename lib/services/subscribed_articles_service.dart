import 'dart:convert';

import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/models/graphql_body.dart';
import 'package:readr_app/models/subscribed_article.dart';
import 'package:readr_app/services/member_service.dart';

class SubscribedArticlesService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<SubscribedArticle>> getSubscribedArticles(
      String firebaseId, String token) async {
    String query = """
    query fetchMemberSubscriptions(\$firebaseId: String!) {
      member(where: { firebaseId: \$firebaseId }) {
        subscription(orderBy: { oneTimeEndDatetime: asc },where: { frequency: one_time, isActive: true }) {
          oneTimeEndDatetime
          postId
        }
      }
    }
    """;
    Map<String, String> variables = {"firebaseId": firebaseId};
    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: MemberService.getHeaders(token),
    );

    List<SubscribedArticle> subscribedArticles = [];
    if (jsonResponse['data']['member']['subscription'] != null) {
      jsonResponse['data']['member']['subscription'].forEach((v) {
        subscribedArticles.add(SubscribedArticle.fromJson(v));
      });

      List<String> articleIds = [];
      for (var element in subscribedArticles) {
        articleIds.add('"${element.postId}"');
      }
      String endpoint =
          '${Environment().config.apiBase}getposts?where={"_id":{"\$in":$articleIds}}';
      final jsonPostResponse = await _helper.getByUrl(endpoint);
      if (jsonPostResponse['_items'] != null) {
        jsonPostResponse['_items'].forEach((item) {
          String photoUrl = Environment().config.mirrorMediaNotImageUrl;
          if (item.containsKey('heroImage') &&
              item['heroImage'] != null &&
              item['heroImage']['image'] != null) {
            photoUrl =
                item['heroImage']['image']['resizedTargets']['mobile']['url'];
          } else if (item.containsKey('snippet') && item['snippet'] != null) {
            photoUrl = item['snippet']['thumbnails']['medium']['url'];
          } else if (item.containsKey('photoUrl') && item['photoUrl'] != null) {
            photoUrl = item['photoUrl'];
          }
          String slug = item['slug'] ?? '';
          String title = item['title'] ?? '';
          if (slug != '' && title != '') {
            subscribedArticles
                .firstWhere((element) => element.postId == item['_id'])
              ..slug = slug
              ..title = title
              ..photoUrl = photoUrl;
          } else {
            subscribedArticles
                .removeWhere((element) => element.postId == item['_id']);
          }
        });
      }
    }

    return subscribedArticles;
  }
}
