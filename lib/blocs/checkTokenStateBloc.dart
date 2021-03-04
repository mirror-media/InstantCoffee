import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/services/memberService.dart';

class CheckTokenStateBloc {
  MemberService _memberService;

  StreamController _checkTokenStateController;

  StreamSink<ApiResponse<bool>> get checkTokenStateSink =>
      _checkTokenStateController.sink;

  Stream<ApiResponse<bool>> get checkTokenStateStream =>
      _checkTokenStateController.stream;

  CheckTokenStateBloc() {
    _memberService = MemberService();
    _checkTokenStateController = StreamController<ApiResponse<bool>>();
  }

  sinkToAdd(ApiResponse<bool> value) {
    if (!_checkTokenStateController.isClosed) {
      checkTokenStateSink.add(value);
    }
  }

  Future<void> checkTokenState(BuildContext context) async{
    sinkToAdd(ApiResponse.loading('Checking Token State'));

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String token = await auth.currentUser?.getIdToken();
      bool isLogin = await _memberService.checkTokenState(token);

      if(isLogin) {
        RouteGenerator.navigateToMagazine(context);
      } else {
        RouteGenerator.navigateToMember(
          context, 
          routeName: RouteGenerator.magazine
        );
      }
      sinkToAdd(ApiResponse.completed(isLogin));
    } catch (e) {
      sinkToAdd(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _checkTokenStateController?.close();
  }
}