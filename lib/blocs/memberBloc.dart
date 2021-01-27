import 'dart:async';

import 'package:readr_app/helpers/memberResponse.dart';
import 'package:readr_app/models/userData.dart';

class MemberBloc {
  StreamController _userDataController;
  StreamSink<MemberResponse<UserData>> get userDataSink => _userDataController.sink;
  Stream<MemberResponse<UserData>> get userDataStream => _userDataController.stream;
  
  MemberBloc() {
    _userDataController = StreamController<MemberResponse<UserData>>();
  }

  sinkToAdd(MemberResponse<UserData> value) {
    if (!_userDataController.isClosed) {
      userDataSink.add(value);
    }
  }

  saveUserDate(UserData userData) async{
    sinkToAdd(MemberResponse.savingLoading(userData, 'save loading'));
    await Future.delayed(Duration(seconds: 2));
    sinkToAdd(MemberResponse.savingSuccessfully(userData));
    //sinkToAdd(MemberResponse.savingError(userData, 'error'));
    await Future.delayed(Duration(seconds: 1));
    sinkToAdd(MemberResponse.completed(userData));
  }

  dispose() {
    _userDataController?.close();
  }
}