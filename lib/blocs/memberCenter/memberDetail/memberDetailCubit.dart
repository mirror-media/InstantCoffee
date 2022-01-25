import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/memberSubscriptionDetail.dart';
import 'package:readr_app/services/memberService.dart';

part 'memberDetailState.dart';

class MemberDetailCubit extends Cubit<MemberDetailState> {
  MemberDetailCubit() : super(MemberDetailInitial());

  void fetchMemberDetail() async {
    print('Get member details');
    try {
      emit(MemberDetailLoading());
      User user = FirebaseAuth.instance.currentUser!;
      String token = await user.getIdToken();
      MemberService memberService = MemberService();
      MemberSubscriptionDetail memberSubscriptionDetail = await memberService.fetchMemberSubscriptionDetail(
        user.uid,
        token
      );
      emit(MemberDetailLoad(memberSubscriptionDetail: memberSubscriptionDetail));
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
