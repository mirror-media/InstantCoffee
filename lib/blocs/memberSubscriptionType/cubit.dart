import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/services/memberService.dart';

class MemberSubscriptionTypeCubit extends Cubit<MemberSubscriptionTypeState> {
  MemberSubscriptionTypeCubit() : super(MemberSubscriptionTypeInitState());

  void fetchMemberSubscriptionType() async {
    print('Fetch member subscription type');
    emit(MemberSubscriptionTypeLoadingState());
    SubscriptionType? subscriptionType;
    FirebaseAuth auth = FirebaseAuth.instance;
    if(auth.currentUser == null) {
      emit(MemberSubscriptionTypeLoadedState(subscriptionType: subscriptionType));
    } else {
      try {
        MemberService memberService = MemberService();
        MemberIdAndSubscriptionType memberIdAndSubscriptionType = await memberService.checkSubscriptionType(auth.currentUser!);
        subscriptionType = memberIdAndSubscriptionType.subscriptionType;
        emit(MemberSubscriptionTypeLoadedState(subscriptionType: subscriptionType));
      } catch(e) {
        // fetch member subscription type fail
        print(e.toString());
        emit(MemberSubscriptionTypeLoadedState(subscriptionType: subscriptionType));
      }
    }
  }
}