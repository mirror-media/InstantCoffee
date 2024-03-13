import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:readr_app/core/values/query.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/graphql_body.dart';
import 'package:readr_app/models/member_info.dart';
import 'package:readr_app/models/member_subscription_type.dart';

import '../../helpers/api_base_helper.dart';

class AuthApiProvider extends GetConnect {
  AuthApiProvider._();

  static final AuthApiProvider _instance = AuthApiProvider._();

  static AuthApiProvider get instance => _instance;

  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  ValueNotifier<GraphQLClient>? client;
  Worker? accessTokeWorker;

  @override
  void onInit() {
    initGraphQLLink();
  }

  static Map<String, String> getHeaders(String? token) {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }

    return headers;
  }

  Future<String?> getAccessTokenByIdToken(String idToken) async {
    final result = await apiBaseHelper.postByUrl(
        '${Environment().config.weeklyAPIServer}/access-token', null,
        headers: {'authorization': 'Bearer $idToken'});

    if (result['status'] == 'success') {
      return result['data']['access_token'];
    }
    return null;
  }

  void initGraphQLLink() {
    final Link link = HttpLink(Environment().config.weeklyAPIPath);

    client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: link,
      ),
    );
  }

  Future<MemberInfo?> checkSubscriptionType(User user) async {
    String? token = await user.getIdToken();
    if (token == null) {
      return null;
    }
    String queryString = QueryDB.checkSubscriptType;
    Map<String, String> variables = {"firebaseId": user.uid};

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: queryString,
      variables: variables,
    );

    final jsonResponse = await apiBaseHelper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    if ((jsonResponse['data']['allMembers'] != null &&
            jsonResponse['data']['allMembers'].length == 0) ||
        (jsonResponse['data']['allMembers'] == null &&
            !jsonResponse.containsKey('errors'))) {
      return null;
    }

    MemberInfo result =MemberInfo.fromJson(jsonResponse['data']['allMembers'][0]);
    if (user.emailVerified) {
      String domain = user.email!.split('@')[1];
      if (mirrormediaGroupDomain.contains(domain)) {
        result.subscriptionType = SubscriptionType.staff;
      }
    }

    return result;
  }
}
