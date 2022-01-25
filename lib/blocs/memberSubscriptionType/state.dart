import 'package:readr_app/models/memberSubscriptionType.dart';

abstract class MemberSubscriptionTypeState {}

class MemberSubscriptionTypeInitState extends MemberSubscriptionTypeState {}

class MemberSubscriptionTypeLoadingState extends MemberSubscriptionTypeState {}

class MemberSubscriptionTypeLoadedState extends MemberSubscriptionTypeState {
  final SubscriptionType? subscriptionType;
  MemberSubscriptionTypeLoadedState({required this.subscriptionType});
}