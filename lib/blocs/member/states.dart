import 'package:readr_app/models/memberSubscriptionType.dart';

enum MemberStatus { 
  loading,
  loaded,
  error 
}

class MemberState {
  final MemberStatus status;
  final bool? isLogin;
  final String? israfelId;
  final SubscriptionType? subscriptionType;
  final dynamic errorMessages;

  const MemberState({
    required this.status,
    this.isLogin,
    this.israfelId,
    this.subscriptionType,
    this.errorMessages,
  });

  factory MemberState.isNotLogin() {
    return MemberState(
      status: MemberStatus.loaded,
      isLogin: false,
    );
  }


  factory MemberState.loading() {
    return MemberState(
      status: MemberStatus.loading
    );
  }

  factory MemberState.loaded({
    required bool isLogin,
    required String? israfelId,
    required SubscriptionType? subscriptionType,
  }) {
    return MemberState(
      status: MemberStatus.loaded,
      isLogin: isLogin,
      israfelId: israfelId,
      subscriptionType: subscriptionType,
    );
  }

  factory MemberState.error({
    dynamic errorMessages
  }) {
    return MemberState(
      status: MemberStatus.error,
      isLogin: false,
      errorMessages: errorMessages,
    );
  }

  bool get isPremium => 
      this.isLogin! && 
      this.subscriptionType != SubscriptionType.none &&
      this.subscriptionType != SubscriptionType.subscribe_one_time;
}