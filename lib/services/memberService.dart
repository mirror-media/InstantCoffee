import 'dart:convert';

import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/createMemberRes.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/userData.dart';

class MemberService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<bool> createMember(String email, String firebaseId, String token, {String nickname}) async{
    String mutation = 
    """
    mutation (\$email: String!, \$firebaseId : String!, \$nickname : String){
      createMember(email: \$email, firebaseId: \$firebaseId, nickname: \$nickname) {
        success
        msg
      }
    }
    """;
    Map<String,String> variables = {"email" : "$email", "firebaseId" : "$firebaseId"};

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        env.baseConfig.graphqlApi,
        jsonEncode(graphqlBody.toJson()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }
      );

      CreateMemberRes createMemberRes = CreateMemberRes.fromJson(jsonResponse['data']['createMember']);
      return createMemberRes.success;
    } catch(e) {
      return false;
    }
  }

  Future<UserData> fetchMemberData(String firebaseId, String token) async{
    String query = 
    """
    query (\$firebaseId : String!){
        member(firebaseId: \$firebaseId) {
            email
            name
            gender
            birthday
            phone
            country
            city
            district
            address
        }
    }
    """;
    Map<String,String> variables = {"firebaseId" : "$firebaseId"};

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      env.baseConfig.graphqlApi,
      jsonEncode(graphqlBody.toJson()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    UserData userData = UserData.fromJson(jsonResponse['data']['member']);
    return userData;
  }
}