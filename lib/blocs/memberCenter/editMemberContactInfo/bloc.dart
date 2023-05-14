import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

class EditMemberContactInfoBloc
    extends Bloc<EditMemberContactInfoEvents, EditMemberContactInfoState>
    with Logger {
  final MemberRepos memberRepos;
  EditMemberContactInfoBloc({required this.memberRepos})
      : super(EditMemberContactInfoInitState()) {
    on<FetchMemberContactInfo>(
      (event, emit) async {
        debugLog(event.toString());
        try {
          emit(MemberLoading());
          FirebaseAuth auth = FirebaseAuth.instance;
          String token = await auth.currentUser!.getIdToken();
          Member member = await memberRepos.fetchMemberInformation(
              auth.currentUser!.uid, token);
          emit(MemberLoaded(member: member));
        } catch (e) {
          emit(MemberLoadedError(
            error: determineException(e),
          ));
        }
      },
    );
    on<UpdateMemberContactInfo>(
      (event, emit) async {
        FirebaseAuth auth = FirebaseAuth.instance;
        debugLog(event.toString());
        emit(SavingLoading(member: event.editMember));
        String token = await auth.currentUser!.getIdToken();
        bool updateSuccess = await memberRepos.updateMemberContactInfo(
            event.editMember.israfelId,
            token,
            event.editMember.phoneNumber,
            event.editMember.contactAddress.country,
            event.editMember.contactAddress.city,
            event.editMember.contactAddress.district,
            event.editMember.contactAddress.address);

        if (updateSuccess) {
          Fluttertoast.showToast(
              msg: '儲存成功',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: '儲存失敗，請再試一次',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        RouteGenerator.navigatorKey.currentState!.pop();
      },
    );
    on<ChangeMember>(
      (event, emit) {
        debugLog(event.toString());
        emit(MemberLoaded(member: event.member));
      },
    );
  }
}
