import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/memberService.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/states.dart';

abstract class EditMemberContactInfoEvents{
  Stream<EditMemberContactInfoState> run(MemberRepos memberRepos);
}

class FetchMemberContactInfo extends EditMemberContactInfoEvents {
  FetchMemberContactInfo();

  @override
  String toString() => 'FetchMemberContactInfo';

  @override
  Stream<EditMemberContactInfoState> run(MemberRepos memberRepos) async*{
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

class UpdateMemberContactInfo extends EditMemberContactInfoEvents {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final Member editMember;
  UpdateMemberContactInfo({
    this.editMember,
  });

  @override
  String toString() => 'UpdateMemberContactInfo';

  @override
  Stream<EditMemberContactInfoState> run(MemberRepos memberRepos) async*{
    print(this.toString());
    yield SavingLoading(member: editMember);
    String token = await _auth.currentUser.getIdToken();
    bool updateSuccess = await memberRepos.updateMemberContactInfo(
      _auth.currentUser.uid, 
      token, 
      editMember.phoneNumber, 
      editMember.contactAddress.country, 
      editMember.contactAddress.city, 
      editMember.contactAddress.district, 
      editMember.contactAddress.address
    );

    if(updateSuccess) {
      yield SavingSuccess(member: editMember);
    } else {
      yield SavingError(member: editMember);
    }
  }
}

class ChangeMember extends EditMemberContactInfoEvents {
  final Member member;
  ChangeMember({
    this.member,
  });
  @override
  String toString() => 'ChangeMember';

  @override
  Stream<EditMemberContactInfoState> run(MemberRepos memberRepos) async*{
    print(this.toString());
    yield MemberLoaded(member: member);
  }
}