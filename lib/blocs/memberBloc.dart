import 'dart:async';

import 'package:readr_app/helpers/memberResponse.dart';
import 'package:readr_app/models/member.dart';

class MemberBloc {
  StreamController _memberController;
  StreamSink<MemberResponse<Member>> get memberSink => _memberController.sink;
  Stream<MemberResponse<Member>> get memberStream => _memberController.stream;
  
  MemberBloc() {
    _memberController = StreamController<MemberResponse<Member>>();
  }

  sinkToAdd(MemberResponse<Member> value) {
    if (!_memberController.isClosed) {
      memberSink.add(value);
    }
  }

  saveMember(Member member) async{
    sinkToAdd(MemberResponse.savingLoading(member, 'save loading'));
    await Future.delayed(Duration(seconds: 2));
    sinkToAdd(MemberResponse.savingSuccessfully(member));
    //sinkToAdd(MemberResponse.savingError(member, 'error'));
    await Future.delayed(Duration(seconds: 1));
    sinkToAdd(MemberResponse.completed(member));
  }

  dispose() {
    _memberController?.close();
  }
}