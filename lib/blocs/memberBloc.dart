import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/helpers/memberResponse.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/memberService.dart';

class MemberBloc {
  FirebaseAuth auth;
  bool passwordUpdateSuccess;

  StreamController _memberController;
  StreamSink<MemberResponse<Member>> get memberSink => _memberController.sink;
  Stream<MemberResponse<Member>> get memberStream => _memberController.stream;
  
  MemberBloc() {
    auth = FirebaseAuth.instance;
    _memberController = StreamController<MemberResponse<Member>>();
  }

  sinkToAdd(MemberResponse<Member> value) {
    if (!_memberController.isClosed) {
      memberSink.add(value);
    }
  }

  saveMember(Member member, Member editMember, {bool isProfile = true}) async{
    sinkToAdd(MemberResponse.savingLoading(member, 'save loading'));
    String token = await auth.currentUser.getIdToken();
    MemberService memberService = MemberService();
    bool updateSuccess = false;
    if(isProfile) {
      updateSuccess = await memberService.updateMemberProfile(
        auth.currentUser.uid, 
        token, 
        editMember.name, 
        editMember.gender, 
        editMember.birthday
      );
    } else {
      updateSuccess = await memberService.updateMemberContactInfo(
        auth.currentUser.uid, 
        token, 
        editMember.phoneNumber, 
        editMember.contactAddress.country, 
        editMember.contactAddress.city, 
        editMember.contactAddress.district, 
        editMember.contactAddress.address
      );
    }

    if(updateSuccess) {
      sinkToAdd(MemberResponse.savingSuccessfully(editMember));
    } else {
      sinkToAdd(MemberResponse.savingError(member, 'error'));
    }

    await Future.delayed(Duration(seconds: 1));

    if(updateSuccess) {
      sinkToAdd(MemberResponse.completed(editMember));
    } else {
      sinkToAdd(MemberResponse.completed(member));
    }
  }

  dispose() {
    _memberController?.close();
  }
}