import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

class MemberSubscriptionTypeCubit extends Cubit<MemberSubscriptionTypeState>
    with Logger {
  MemberSubscriptionTypeCubit() : super(MemberSubscriptionTypeInitState());

  void fetchMemberSubscriptionType({
    bool isNavigateToMagazine = false,
  }) async {
    debugLog('Fetch member subscription type');
    emit(MemberSubscriptionTypeLoadingState());
    SubscriptionType? subscriptionType;
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      emit(MemberSubscriptionTypeLoadedState(
          subscriptionType: subscriptionType));
      if (isNavigateToMagazine) {
        RouteGenerator.navigateToLogin(
          routeName: RouteGenerator.magazine,
          routeArguments: {
            'subscriptionType': subscriptionType,
          },
        );
      }
    } else {
      try {
        MemberService memberService = MemberService();
        MemberIdAndSubscriptionType memberIdAndSubscriptionType =
            await memberService.checkSubscriptionType(auth.currentUser!);
        subscriptionType = memberIdAndSubscriptionType.subscriptionType;
        emit(MemberSubscriptionTypeLoadedState(
            subscriptionType: subscriptionType));
        if (isNavigateToMagazine) {
          if (subscriptionType != null) {
            RouteGenerator.navigateToMagazine(subscriptionType);
          } else {
            RouteGenerator.navigateToLogin(
              routeName: RouteGenerator.magazine,
              routeArguments: {
                'subscriptionType': subscriptionType,
              },
            );
          }
        }
      } catch (e) {
        // fetch member subscription type fail
        debugLog(e.toString());
        emit(MemberSubscriptionTypeLoadedState(
            subscriptionType: subscriptionType));
      }
    }
  }
}
