import 'dart:convert';

import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/member.dart';

class MemberService {
  ApiBaseHelper _helper = ApiBaseHelper();

  static Map<String,String> getHeaders(String token) {
    Map<String,String> headers = {
      "Content-Type": "application/json",
    };
    if(token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }

    return headers;
  }

  Future<bool> createMember(String email, String token) async{
    String mutation = 
    """
    mutation (\$email: String!){
      createmember(data: { email: \$email }) {
        email
        firebaseId
      }
    }
    """;

    Map<String,String> variables = {
      "email" : "$email",
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        env.baseConfig.memberApi,
        jsonEncode(graphqlBody.toJson()),
        headers: getHeaders(token),
      );

      return !jsonResponse.containsKey('errors');
    } catch(e) {
      return false;
    }
  }

  Future<Member> fetchMemberData(String firebaseId, String token) async{
    String query = 
    """
    query (\$firebaseId: String!) {
      member(where: { firebaseId: \$firebaseId }) {
        id
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
      env.baseConfig.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    Member member = Member.fromJson(jsonResponse['data']['member']);
    return member;
  }

  Future<bool> updateMemberProfile(
    String israfelId, 
    String token, 
    String name, 
    Gender gender, 
    String birthday
  ) async{
    String mutation = 
    """
    mutation (
      \$id: ID!,
      \$name: String,
      \$gender: memberGenderType, 
      \$birthday: String, 
    ){
      updatemember(
        id: \$id
        data: {
          name: \$name
          gender: \$gender
          birthday: \$birthday
        }
      ) {
        name,
        gender,
        birthday,
      }
    }
    """;
    Map<String,String> variables = {
      "id" : "$israfelId",
      "name" : name == null ? "" : "$name",
      "gender" : gender == null ? "${Gender.NA.toString().split('.')[1]}" : "${gender.toString().split('.')[1]}",
      "birthday" : birthday == null ? null : "$birthday",
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        env.baseConfig.memberApi,
        jsonEncode(graphqlBody.toJson()),
        headers: getHeaders(token),
      );

      return !jsonResponse.containsKey('errors');
    } catch(e) {
      return false;
    }
  }

  Future<bool> updateMemberContactInfo(
    String israfelId, 
    String token, 
    String phone, 
    String country, 
    String city, 
    String district, 
    String address
  ) async{
    String mutation = 
    """
    mutation (
      \$id: ID!,
      \$phone: String,
      \$country: String, 
      \$city: String, 
      \$district: String, 
      \$address: String
    ){
      updatemember(
        id: \$id
        data: {
          phone: \$phone
          country: \$country
          city: \$city
          district: \$district
          address: \$address
        }
      ) {
        phone,
        country,
        city,
        district,
        address
      }
    }
    """;
    Map<String,String> variables = {
      "id" : "$israfelId",
      "phone" : phone == null ? "" : "$phone",
      "country" : country == null ? "" : "$country",
      "city" : city == null ? "" : "$city",
      "district" : district == null ? "" : "$district",
      "address" : address == null ? "" : "$address",
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        env.baseConfig.memberApi,
        jsonEncode(graphqlBody.toJson()),
        headers: getHeaders(token),
      );

      return !jsonResponse.containsKey('errors');
    } catch(e) {
      return false;
    }
  }

  Future<bool> deleteMember(String israfelId, String token) async{
    String mutation = 
    """
    mutation (\$id: ID!) {
      updatemember(id: \$id, data: { state: inactive }) {
        email
        state
      }
    }
    """;
    Map<String,String> variables = {
      "id" : "$israfelId"
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        env.baseConfig.memberApi,
        jsonEncode(graphqlBody.toJson()),
        headers: getHeaders(token),
      );

      return !jsonResponse.containsKey('errors');
    } catch(e) {
      return false;
    }
  }

  Future<bool> checkTokenState(String token) async{
    try {
      final jsonResponse = await _helper.getByUrl(
        env.baseConfig.tokenStateApi,
        headers: getHeaders(token),
      );

      return jsonResponse['tokenState'] == 'OK';
    } catch(e) {
      return false;
    }
  }
}