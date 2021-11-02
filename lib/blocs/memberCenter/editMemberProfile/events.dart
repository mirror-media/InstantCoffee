import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/memberService.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/states.dart';

abstract class EditMemberProfileEvents{
  Stream<EditMemberProfileState> run(MemberRepos memberRepos);
}

class FetchMemberProfile extends EditMemberProfileEvents {
  FetchMemberProfile();

  @override
  String toString() => 'FetchMemberProfile';

  @override
  Stream<EditMemberProfileState> run(MemberRepos memberRepos) async*{
    print(this.toString());
    try {
      yield MemberLoading();
      FirebaseAuth auth = FirebaseAuth.instance;
      String token = await auth.currentUser.getIdToken();
      Member member = await memberRepos.fetchMemberData(auth.currentUser.uid, token);
      yield MemberLoaded(member: member);
    } on SocketException {
      yield MemberLoadedError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield MemberLoadedError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield MemberLoadedError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } on FetchDataException {
      yield MemberLoadedError(
        error: NoInternetException('Error During Communication'),
      );
    } on BadRequestException {
      yield MemberLoadedError(
        error: Error400Exception('Invalid Request'),
      );
    } on UnauthorisedException {
      yield MemberLoadedError(
        error: Error400Exception('Unauthorised'),
      );
    } on InvalidInputException {
      yield MemberLoadedError(
        error: Error400Exception('Invalid Input'),
      );
    } on InternalServerErrorException {
      yield MemberLoadedError(
        error: NoServiceFoundException('Internal Server Error'),
      );
    } catch (e) {
      yield MemberLoadedError(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class UpdateMemberProfile extends EditMemberProfileEvents {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final Member editMember;
  UpdateMemberProfile({
    this.editMember,
  });

  @override
  String toString() => 'UpdateMemberProfile';

  @override
  Stream<EditMemberProfileState> run(MemberRepos memberRepos) async*{
    print(this.toString());
    yield SavingLoading(member: editMember);
    String token = await _auth.currentUser.getIdToken();
    bool updateSuccess = await memberRepos.updateMemberProfile(
      editMember.israfelId,
      token,
      editMember.name,
      editMember.gender,
      editMember.birthday
    );

    if(updateSuccess) {
      Fluttertoast.showToast(
        msg: '儲存成功',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
        msg: '儲存失敗，請再試一次',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }

    RouteGenerator.navigatorKey.currentState.pop();
  }
}