import 'dart:convert';

import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/memberRes.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/member.dart';

class MemberService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<bool> createMember(String email, String firebaseId, String token, {String nickname}) async{
    String mutation = 
    """
    mutation (\$email: String, \$firebaseId : String!){
      createMember(email: \$email, firebaseId: \$firebaseId) {
        success
        msg
      }
    }
    """;

    Map<String,String> variables = {
      "email" : email == null ? null : "$email", 
      "firebaseId" : "$firebaseId"
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
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }
      );

      MemberRes memberRes = MemberRes.fromJson(jsonResponse['data']['createMember']);
      return memberRes.success;
    } catch(e) {
      return false;
    }
  }

  Future<Member> fetchMemberData(String firebaseId, String token) async{
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
      env.baseConfig.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer $token",
      }
    );

    Member member = Member.fromJson(jsonResponse['data']['member']);
    return member;
  }

  Future<bool> updateMemberProfile(String firebaseId, String token, String name, Gender gender, String birthday) async{
    String mutation = 
    """
    mutation (\$address: String, \$birthday: Date, \$city: String, \$country: String, \$district: String, \$firebaseId: String!, \$gender: Int, \$name: String, \$nickname: String, \$phone: String, \$profileImage: String){
      updateMember(address: \$address, birthday: \$birthday, city: \$city, country: \$country, district: \$district, firebaseId: \$firebaseId, gender: \$gender, name: \$name, nickname: \$nickname, phone: \$phone, profileImage: \$profileImage) {
        success
      }
    }
    """;
    Map<String,String> variables = {
      "firebaseId" : "$firebaseId",
      "name" : name == null ? "" : "$name",
      "gender" : gender == null ? "${Gender.A_0.index}" : "${gender.index}",
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
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }
      );

      MemberRes memberRes = MemberRes.fromJson(jsonResponse['data']['updateMember']);
      return memberRes.success;
    } catch(e) {
      return false;
    }
  }

  Future<bool> updateMemberContactInfo(String firebaseId, String token, String phoneNumber, String country, String city, String district, String address) async{
    String mutation = 
    """
    mutation (\$address: String, \$birthday: Date, \$city: String, \$country: String, \$district: String, \$firebaseId: String!, \$gender: Int, \$name: String, \$nickname: String, \$phone: String, \$profileImage: String){
      updateMember(address: \$address, birthday: \$birthday, city: \$city, country: \$country, district: \$district, firebaseId: \$firebaseId, gender: \$gender, name: \$name, nickname: \$nickname, phone: \$phone, profileImage: \$profileImage) {
        success
      }
    }
    """;
    Map<String,String> variables = {
      "firebaseId" : "$firebaseId",
      "phone" : phoneNumber == null ? "" : "$phoneNumber",
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
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }
      );

      MemberRes memberRes = MemberRes.fromJson(jsonResponse['data']['updateMember']);
      return memberRes.success;
    } catch(e) {
      return false;
    }
  }

  Future<bool> deleteMember(String firebaseId, String token) async{
    String mutation = 
    """
    mutation (\$firebaseId: String!){
        deleteMember(firebaseId: \$firebaseId) {
            success
        }
    }
    """;
    Map<String,String> variables = {
      "firebaseId" : "$firebaseId"
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
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }
      );

      MemberRes memberRes = MemberRes.fromJson(jsonResponse['data']['deleteMember']);
      return memberRes.success;
    } catch(e) {
      return false;
    }
  }

  Future<bool> checkTokenState(String token) async{
    try {
      final jsonResponse = await _helper.getByUrl(
        env.baseConfig.graphqlApi+"api/v1/tokenState",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }
      );

      return jsonResponse['tokenState'] == 'OK';
    } catch(e) {
      return false;
    }
  }
}