import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/deleteMember/state.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

class DeleteMemberCubit extends Cubit<DeleteMemberState> with Logger {
  DeleteMemberCubit() : super(DeleteMemberInitState());

  void deleteMember(String israfelId) async {
    debugLog('Delete member');
    emit(DeleteMemberLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();
    MemberService memberService = MemberService();
    bool deleteSuccess = await memberService.deleteMember(israfelId, token);
    if (deleteSuccess) {
      try {
        await auth.currentUser!.delete();
        emit(DeleteMemberSuccess());
      } catch (e) {
        debugLog('firebase account delete fail');
        await auth.signOut();
        emit(DeleteMemberError());
      }
    } else {
      emit(DeleteMemberError());
    }
  }
}
