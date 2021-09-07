import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/memberDetail.dart';
import 'package:readr_app/services/memberDetailService.dart';

part 'memberdetail_state.dart';

class MemberdetailCubit extends Cubit<MemberdetailState> {
  MemberdetailCubit() : super(MemberdetailInitial());

  void fetchMemberDetail() async {
    print('Get member details');
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String token = await auth.currentUser.getIdToken();
      MemberDetailService memberDetailService = MemberDetailService();
      MemberDetail memberDetail = await memberDetailService.getMemberDetail(
          auth.currentUser.uid, token);
      emit(MemberDetailLoad(memberDetail: memberDetail));
    } on SocketException {
      emit(MemberDetailError(
        error: NoInternetException('No Internet'),
      ));
    } on HttpException {
      emit(MemberDetailError(
        error: NoServiceFoundException('No Service Found'),
      ));
    } on FormatException {
      emit(MemberDetailError(
        error: InvalidFormatException('Invalid Response format'),
      ));
    } catch (e) {
      emit(MemberDetailError(
        error: UnknownException(e.toString()),
      ));
    }
  }
}
