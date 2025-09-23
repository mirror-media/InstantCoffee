import 'package:readr_app/models/member_subscription_type.dart';

abstract class MemberEvents {}

class FetchMemberSubscriptionType extends MemberEvents {
  @override
  String toString() => 'FetchMemberSubscriptionType';
}

class UpdateSubscriptionType extends MemberEvents {
  final bool isLogin;
  final String? israfelId;
  final SubscriptionType? subscriptionType;
  UpdateSubscriptionType({
    required this.isLogin,
    required this.israfelId,
    required this.subscriptionType,
  });

  @override
  String toString() =>
      'UpdateSubscriptionType: { isLogin: $isLogin, subscriptionType: $subscriptionType }';
}

class RefreshMemberStatus extends MemberEvents {
  @override
  String toString() => 'RefreshMemberStatus';
}
