import 'dart:convert';

import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/memberRes.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

abstract class MemberRepos {
  Future<SubscritionType> checkSubscriptionType(String firebaseId, String token);
  Future<bool> createMember(String email, String token);
  Future<Member> fetchMemberData(String firebaseId, String token);
  Future<bool> updateMemberProfile(String firebaseId, String token, String name, Gender gender, String birthday);
  Future<bool> updateMemberContactInfo(String firebaseId, String token, String phoneNumber, String country, String city, String district, String address);
  Future<bool> deleteMember(String firebaseId, String token);
}

class MemberService implements MemberRepos{
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

  @override
  Future<SubscritionType> checkSubscriptionType(String firebaseId, String token) async{
    String query = 
    """
    query checkSubscriptionType(\$firebaseId: String!) {
      member(where: { firebaseId: \$firebaseId }) {
        type
        subscription(
          where: { 
            frequency_not: one_time,
            isActive: true
          }
        ) {
          frequency
        }
      }
    }
    """;

    Map<String,String> variables = {
      "firebaseId" : "$firebaseId"
    };

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

    MemberSubscritionType memberSubscritionType = MemberSubscritionType.fromJson(jsonResponse['data']['member']);
    
    if(memberSubscritionType.subscriptionList != null) {
      if(memberSubscritionType.subscriptionList.contains('marketing')) {
        return SubscritionType.marketing; 
      } else if(memberSubscritionType.subscriptionList.contains('yearly')) {
        return SubscritionType.yearly_subscriber; 
      } else if(memberSubscritionType.subscriptionList.contains('monthly')) {
        return SubscritionType.monthly_subscriber; 
      }
    }

    return SubscritionType.none;
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
      headers: getHeaders(token),
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
        headers: getHeaders(token),
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
        headers: getHeaders(token),
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
        headers: getHeaders(token),
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
        env.baseConfig.tokenStateApi,
        headers: getHeaders(token),
      );

      return jsonResponse['tokenState'] == 'OK';
    } catch(e) {
      return false;
    }
  }
}