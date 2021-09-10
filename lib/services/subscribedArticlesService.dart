import 'dart:convert';

import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/subscribedArticle.dart';

class SubscribedArticlesService {
  ApiBaseHelper _helper = ApiBaseHelper();

  static Map<String, String> getHeaders(String token) {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }
    
    return headers;
  }

  Future<List<SubscribedArticle>> getSubscribedArticles(
      String firebaseId, String token) async {
    String query = """
    query fetchMemberSubscriptions(\$firebaseId: String!) {
      member(where: { firebaseId: \$firebaseId }) {
        subscription(orderBy: [{ oneTimeEndDatetime: asc }]) {
          oneTimeEndDatetime
          postId
        }
      }
    }
    """;
    Map<String, String> variables = {"firebaseId": "$firebaseId"};
    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      env.baseConfig.israfel,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    List<SubscribedArticle> subscribedArticles = [];
    if (jsonResponse['data']['member']['subscription'] != null) {
      jsonResponse['data']['member']['subscription'].forEach((v) {
        subscribedArticles.add(SubscribedArticle.fromJson(v));
      });
      subscribedArticles.removeWhere(
          (element) => element.oneTimeEndDatetime.isBefore(DateTime.now()));
    }
    
    return subscribedArticles;
  }
}
