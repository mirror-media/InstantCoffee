import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/core/values/auth_query.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/graphql_body.dart';
import 'package:readr_app/models/user_auth_info.dart';
import 'package:readr_app/services/member_service.dart';

import '../../helpers/api_base_helper.dart';

class AuthApiProvider extends GetConnect {
  AuthApiProvider._();

  static final AuthApiProvider _instance = AuthApiProvider._();

  static AuthApiProvider get instance => _instance;

  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? bearerToken;

  late GraphQLClient client;

  void initGraphQLLink() async {
    final HttpLink httpLink = HttpLink(
        'https://app-dev.mirrormedia.mg/api/v2/graphql/member',
        defaultHeaders: {
          'authorization':
              'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjFlNTIxYmY1ZjdhNDAwOGMzYmQ3MjFmMzk2OTcwOWI1MzY0MzA5NjEiLCJ0eXAiOiJKV1QifQ.eyJwcm92aWRlcl9pZCI6ImFub255bW91cyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9taXJyb3JtZWRpYWFwcHRlc3QiLCJhdWQiOiJtaXJyb3JtZWRpYWFwcHRlc3QiLCJhdXRoX3RpbWUiOjE3MzE2NTIxMzIsInVzZXJfaWQiOiI5Y0tCNTBldGJTZDRUenZLNzVmelY4dEptN2kxIiwic3ViIjoiOWNLQjUwZXRiU2Q0VHp2Szc1ZnpWOHRKbTdpMSIsImlhdCI6MTczMTY1MjEzMiwiZXhwIjoxNzMxNjU1NzMyLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7fSwic2lnbl9pbl9wcm92aWRlciI6ImFub255bW91cyJ9fQ.nqm9ipWbM5vV9bOqhwH8G5TO5Efm0Rzp5x9zpSbDZlSGiMTuc8p9MvxS0UL92JKIQPHdeHaYILkT1U3WjRhWYzdl8QR17wf8GnIMx2_s9Yj9b4SnBv_DMwrVu1q46TNmkRKebEajifAXUN7ljpU4McAeCB0Fql1eDdSvbSANP4f0QwSu82qHzjt3awBsthCpnaz8lSS2lyLkWIq8VfnNQO8AYpKm8ZR7KYIlm1a2r8jMPonPegwwFZZhVTuss60aK_WY3y3ZgxLLM_4HS9ZmI1dOZE2kS0JtjYKTgF1-CgbT8rw2I8uitemlkDIwkrbhAgAXUuEGnM3FXmznIURdXA',
          'Content-Type': 'application/json'
        });

    client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );
  }

  Future<UserAuthInfo?> getUserInfoFirebaseId(String firebaseId) async {
    String queryString = AuthQuery.getMemberInfo.format([firebaseId]);
    User user = FirebaseAuth.instance.currentUser!;
    String? token = await user.getIdToken();

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: queryString,
      variables: {},
    );

    final jsonResponse = await apiBaseHelper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    if (jsonResponse == null ||
        jsonResponse['data']['allMembers'] == null ||
        jsonResponse['data']['allMembers'][0] == null) {
      return null;
    }

    return UserAuthInfo.fromJson(jsonResponse['data']['allMembers'][0]);
  }

  @override
  void onInit() {
    _updateToken();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      initGraphQLLink();
      if (user != null) {
        await _updateToken();
      } else {
        bearerToken = "";
      }
    });
  }

  Future<void> _updateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? token = await user?.getIdToken();
    bearerToken = token ?? "";
    initGraphQLLink();
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

  static Map<String, String> getHeaders(String? token) {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }

    return headers;
  }

  Future<String?> verifyPurchaseList(
      List<PurchaseDetails> purchaseDetailsList) async {
    if (purchaseDetailsList.isEmpty) return null;

    String firebaseId = _auth.currentUser!.uid;
    String? token = await _auth.currentUser!.getIdToken();

    Map<String, dynamic> bodyMap = {
      "firebaseId": firebaseId,
      "receiptDataList": purchaseDetailsList
          .map((e) => e.verificationData.serverVerificationData)
          .toList()
          .toSet()
          .toList()
    };

    final jsonResponse = await apiBaseHelper.postByUrl(
      Environment().config.verifyIosPurchaseApi,
      jsonEncode(bodyMap),
      headers: MemberService.getHeaders(token),
    );

    if (!jsonResponse.containsKey('success') ||
        jsonResponse['success'] != true) {
      return null;
    }

    if (jsonResponse['data'][0]['isCanceled'] == true) {
      return 'cancel';
    }

    return jsonResponse['data'][0]['frequency'];
  }

  Future<bool> linkEmailFromAnonymous(
      {required String email,
      required String id,
      required String token}) async {
    String queryString = AuthQuery.updateUserEmail.format([email, id]);
    User user = FirebaseAuth.instance.currentUser!;
    String? token = await user.getIdToken();

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: queryString,
      variables: {},
    );

    final jsonResponse = await apiBaseHelper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    return jsonResponse['data']['updatemember']['id'] != null;
  }

  Future<bool> createMember(
      String email, String firebaseId, String token) async {
    String mutation = """
    mutation (\$email: String!){
      createmember(data: { email: \$email }) {
        email
        firebaseId
        type
        
      }
    }
    """;
    // if facebook authUser has no email,then feed email field with prompt
    String? feededEmail = email;
    feededEmail ??= '[0x0001] - firebaseId:$firebaseId';

    Map<String, String> variables = {
      "email": feededEmail,
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );
    final jsonResponse = await apiBaseHelper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    try {
      return !jsonResponse.containsKey('errors');
    } catch (e) {
      return false;
    }
  }
}
