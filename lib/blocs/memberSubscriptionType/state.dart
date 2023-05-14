import 'package:readr_app/models/member_subscription_type.dart';

abstract class MemberSubscriptionTypeState {}

class MemberSubscriptionTypeInitState extends MemberSubscriptionTypeState {}

class MemberSubscriptionTypeLoadingState extends MemberSubscriptionTypeState {}

class MemberSubscriptionTypeLoadedState extends MemberSubscriptionTypeState {
  final SubscriptionType? subscriptionType;
  MemberSubscriptionTypeLoadedState({required this.subscriptionType});
}
