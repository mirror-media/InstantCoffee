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
    SubscritionType subscritionType = SubscritionType.none;
    FirebaseAuth auth = FirebaseAuth.instance;
    if(auth.currentUser == null) {
      emit(MemberSubscriptionTypeLoadedState(subscritionType: null));
    } else {
      try {
        String token = await auth.currentUser.getIdToken();
        MemberService memberService = MemberService();
        MemberIdAndSubscritionType memberIdAndSubscritionType = await memberService.checkSubscriptionType(auth.currentUser, token);
        subscritionType = memberIdAndSubscritionType.subscritionType;
        emit(MemberSubscriptionTypeLoadedState(subscritionType: subscritionType));
      } catch(e) {
        // fetch member subscription type fail
        print(e.toString());
        emit(MemberSubscriptionTypeLoadedState(subscritionType: subscritionType));
      }
    }
  }
}