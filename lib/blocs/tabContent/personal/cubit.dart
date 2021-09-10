import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/tabContent/personal/state.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/services/memberService.dart';

class MemberSubscriptionTypeCubit extends Cubit<MemberSubscriptionTypeState> {
  MemberSubscriptionTypeCubit() : super(MemberSubscriptionTypeLoadingState());

  void fetchMemberSubscriptionType() async {
    print('Fetch member subscription type');
    SubscritionType subscritionType = SubscritionType.none;
    FirebaseAuth auth = FirebaseAuth.instance;
    if(auth.currentUser == null) {
      emit(MemberSubscriptionTypeLoadedState(subscritionType: null));
    } else {
      try {
        String token = await auth.currentUser.getIdToken();
        MemberService memberService = MemberService();
        subscritionType = await memberService.checkSubscriptionType(auth.currentUser.uid, token);
        emit(MemberSubscriptionTypeLoadedState(subscritionType: subscritionType));
      } catch(e) {
        // fetch member subscription type fail
        print(e.toString());
        emit(MemberSubscriptionTypeLoadedState(subscritionType: subscritionType));
      }
    }
  }
}