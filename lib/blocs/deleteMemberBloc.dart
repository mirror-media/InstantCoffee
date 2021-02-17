import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/helpers/deleteResponse.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/memberService.dart';

class DeleteMemberBloc {
  FirebaseAuth auth;

  StreamController _deleteMemberController;
  StreamSink<DeleteResponse<Member>> get deleteMemberSink =>
      _deleteMemberController.sink;
  Stream<DeleteResponse<Member>> get deleteMemberStream =>
      _deleteMemberController.stream;

  DeleteMemberBloc() {
    auth = FirebaseAuth.instance;
    _deleteMemberController = StreamController<DeleteResponse<Member>>();
  }

  loginSinkToAdd(DeleteResponse<Member> value) {
    if (!_deleteMemberController.isClosed) {
      deleteMemberSink.add(value);
    }
  }

  deleteMember() async{
    loginSinkToAdd(DeleteResponse.deletingLoading());
    MemberService memberService = MemberService();
    String token = await auth.currentUser.getIdToken();
    bool deleteSuccess = await memberService.deleteMember(auth.currentUser.uid, token);
    if(deleteSuccess) {
      await auth.signOut();
      loginSinkToAdd(DeleteResponse.deletingSuccessfully());
    } else {
      loginSinkToAdd(DeleteResponse.deletingError('Delete error'));
    }
  }
  
  dispose() {
    _deleteMemberController?.close();
  }
}