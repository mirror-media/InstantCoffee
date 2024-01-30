import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

class EditMemberProfileBloc
    extends Bloc<EditMemberProfileEvents, EditMemberProfileState> with Logger {
  final MemberRepos memberRepos;
  final FirebaseAuth auth = FirebaseAuth.instance;

  EditMemberProfileBloc({required this.memberRepos})
      : super(EditMemberProfileInitState()) {
    on<FetchMemberProfile>(
      (event, emit) async {
        debugLog(event.toString());
        try {
          emit(MemberLoading());

          String? token = await auth.currentUser!.getIdToken();
          if (token != null) {
            Member member = await memberRepos.fetchMemberInformation(
                auth.currentUser!.uid, token);
            emit(MemberLoaded(member: member));
          }
        } catch (e) {
          emit(MemberLoadedError(
            error: determineException(e),
          ));
        }
      },
    );
    on<UpdateMemberProfile>(
      (event, emit) async {
        debugLog(event.toString());
        emit(SavingLoading(member: event.editMember));
        String? token = await auth.currentUser!.getIdToken();
        if (token != null) {
          bool updateSuccess = await memberRepos.updateMemberProfile(
              event.editMember.israfelId,
              token,
              event.editMember.name,
              event.editMember.gender,
              event.editMember.birthday);

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
        }
      },
    );
  }
}
