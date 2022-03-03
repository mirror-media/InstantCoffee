import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/events.dart';
import 'package:readr_app/blocs/member/states.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/services/memberService.dart';

export 'events.dart';
export 'states.dart';

class MemberBloc extends Bloc<MemberEvents, MemberState> {
  final MemberRepos memberRepos;
  MemberBloc({
    required this.memberRepos
  }) : super(MemberState.init()) {
    on<FetchMemberSubscriptionType>(_fetchMemberSubscriptionType);
    on<UpdateSubscriptionType>(_updateSubscriptionType);
  }

  void _fetchMemberSubscriptionType(
    FetchMemberSubscriptionType event,
    Emitter<MemberState> emit,
  ) async{
    print(event.toString());
    FirebaseAuth auth = FirebaseAuth.instance;
    if(auth.currentUser == null) {
      emit(MemberState.isNotLogin());
    } else {
      try {
        emit(MemberState.loading());
        MemberIdAndSubscriptionType memberIdAndSubscriptionType = await memberRepos.checkSubscriptionType(auth.currentUser!);
        emit(
          MemberState.loaded(
            isLogin: true,
            israfelId: memberIdAndSubscriptionType.israfelId,
            subscriptionType: memberIdAndSubscriptionType.subscriptionType
          ),
        );
      } catch(e) {
        emit(MemberState.error(errorMessages: e));
      }
    }
  }

  void _updateSubscriptionType(
    UpdateSubscriptionType event,
    Emitter<MemberState> emit,
  ) {
    print(event.toString());
    emit(
      MemberState.loaded(
        isLogin: event.isLogin,
        israfelId: event.israfelId,
        subscriptionType: event.subscriptionType
      ),
    );
  }
}