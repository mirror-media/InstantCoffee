import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/deleteMember/state.dart';
import 'package:readr_app/services/memberService.dart';

class DeleteMemberCubit extends Cubit<DeleteMemberState> {
  DeleteMemberCubit() : super(DeleteMemberInitState());

  void deleteMember(String israfelId) async {
    print('Delete member');
    emit(DeleteMemberLoading());
    FirebaseAuth auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();
    MemberService memberService = MemberService();
    bool deleteSuccess = await memberService.deleteMember(israfelId, token);
    if(deleteSuccess) {
      try {
        await auth.currentUser!.delete();
        emit(DeleteMemberSuccess());
      } catch(e) {
        print('firebase account delete fail');
        await auth.signOut();
        emit(DeleteMemberError());
      }
    } else {
      emit(DeleteMemberError());
    }
  }
}