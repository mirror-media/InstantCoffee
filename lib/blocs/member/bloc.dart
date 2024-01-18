import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/events.dart';
import 'package:readr_app/blocs/member/states.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

export 'events.dart';
export 'states.dart';

class MemberBloc extends Bloc<MemberEvents, MemberState> with Logger {
  final MemberRepos memberRepos;

  MemberBloc({required this.memberRepos}) : super(MemberState.loading()) {
    on<FetchMemberSubscriptionType>(_fetchMemberSubscriptionType);
    on<UpdateSubscriptionType>(_updateSubscriptionType);
  }

  void _fetchMemberSubscriptionType(
    FetchMemberSubscriptionType event,
    Emitter<MemberState> emit,
  ) async {
    debugLog(event.toString());
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      emit(MemberState.isNotLogin());
    } else {
      try {
        MemberIdAndSubscriptionType? memberIdAndSubscriptionType =
            await memberRepos.checkSubscriptionType(auth.currentUser!);
        if (memberIdAndSubscriptionType != null) {
          emit(
            MemberState.loaded(
                isLogin: true,
                israfelId: memberIdAndSubscriptionType.israfelId,
                subscriptionType: memberIdAndSubscriptionType.subscriptionType),
          );
        }
      } catch (e) {
        emit(MemberState.error(errorMessages: e));
      }
    }
  }

  void _updateSubscriptionType(
    UpdateSubscriptionType event,
    Emitter<MemberState> emit,
  ) {
    debugLog(event.toString());
    emit(
      MemberState.loaded(
          isLogin: event.isLogin,
          israfelId: event.israfelId,
          subscriptionType: event.subscriptionType),
    );
  }
}
