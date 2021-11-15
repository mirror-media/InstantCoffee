import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

const String memberStateTypeIsNotFound = 'Member state type is not found';
const String memberStateTypeIsNotActive = 'Member state type is not active';

abstract class MemberRepos {
  Future<MemberIdAndSubscritionType> checkSubscriptionType(User user, String token);
  Future<bool> createMember(String email, String firebaseId, String token);
  Future<Member> fetchMemberData(String firebaseId, String token);
  Future<bool> updateMemberProfile(String israfelId, String token, String name, Gender gender, String birthday);
  Future<bool> updateMemberContactInfo(String israfelId, String token, String phoneNumber, String country, String city, String district, String address);
  Future<bool> deleteMember(String israfelId, String token);
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
  Future<MemberIdAndSubscritionType> checkSubscriptionType(User user, String token) async{
    String query = 
    """
    query checkSubscriptionType(\$firebaseId: String!) {
      allMembers(where: { firebaseId: \$firebaseId }) {
        id
        state
        type
      }
    }
    """;

    Map<String,String> variables = {
      "firebaseId" : "${user.uid}"
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    if(jsonResponse['data']['allMembers'] != null && 
    jsonResponse['data']['allMembers'].length == 0) {
      throw BadRequestException(memberStateTypeIsNotFound);
    }

    if(jsonResponse.containsKey('errors')) {
      throw BadRequestException(jsonResponse['errors'][0]['message']);
    }

    MemberIdAndSubscritionType memberIdAndSubscritionType = MemberIdAndSubscritionType.fromJson(jsonResponse['data']['allMembers'][0]);
    if(memberIdAndSubscritionType.state != MemberStateType.active) {
      throw BadRequestException(memberStateTypeIsNotActive);
    }
    if(user.emailVerified){
      String domain = user.email.split('@')[1];
      if(mirrormediaGroupDomain.contains(domain)){
        memberIdAndSubscritionType.subscritionType = SubscritionType.staff;
      }
    }
    return memberIdAndSubscritionType;
  }

  Future<bool> createMember(
    String email, 
    String firebaseId,
    String token
  ) async{
    String mutation = 
    """
    mutation (\$email: String!){
      createmember(data: { email: \$email }) {
        email
        firebaseId
      }
    }
    """;

    // if facebook authUser has no email,then feed email field with prompt
    String feededEmail = email;
    if (feededEmail == null) {
      feededEmail = '[0x0001] - firebaseId:$firebaseId';
    }

    Map<String,String> variables = {
      "email" : "$feededEmail",
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        Environment().config.memberApi,
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
      Environment().config.memberApi,
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
      "name" : name == null ? null : "$name",
      "gender" : gender == null ? null : "${gender.toString().split('.')[1]}",
      "birthday" : birthday == null ? null : "$birthday",
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        Environment().config.memberApi,
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
      "phone" : phone == null ? null : "$phone",
      "country" : country == null ? null : "$country",
      "city" : city == null ? null : "$city",
      "district" : district == null ? null : "$district",
      "address" : address == null ? null : "$address",
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        Environment().config.memberApi,
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
        Environment().config.memberApi,
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
        Environment().config.tokenStateApi,
        headers: getHeaders(token),
      );

      return jsonResponse['tokenState'] == 'OK';
    } catch(e) {
      return false;
    }
  }
}