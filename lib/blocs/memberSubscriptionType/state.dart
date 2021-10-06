import 'package:readr_app/models/memberSubscriptionType.dart';

abstract class MemberSubscriptionTypeState {}

class MemberSubscriptionTypeLoadingState extends MemberSubscriptionTypeState {}

class MemberSubscriptionTypeLoadedState extends MemberSubscriptionTypeState {
  final SubscritionType subscritionType;
  MemberSubscriptionTypeLoadedState({this.subscritionType});
}