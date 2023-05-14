import 'package:readr_app/helpers/enum_parser.dart';

const List<SubscriptionType> premiumSubscriptionType = [
  SubscriptionType.marketing,
  SubscriptionType.subscribe_monthly,
  SubscriptionType.subscribe_yearly,
  SubscriptionType.marketing,
  SubscriptionType.staff,
];

enum SubscriptionType {
  none,
  marketing,
  subscribe_one_time, // ignore: constant_identifier_names
  subscribe_monthly, // ignore: constant_identifier_names
  subscribe_yearly, // ignore: constant_identifier_names
  subscribe_group, // ignore: constant_identifier_names
  staff
}

enum MemberStateType { active, inactive }

class MemberIdAndSubscriptionType {
  final String? israfelId;
  final MemberStateType? state;
  SubscriptionType? subscriptionType;
  final bool isNewebpay;

  MemberIdAndSubscriptionType({
    this.israfelId,
    this.state,
    this.subscriptionType,
    this.isNewebpay = false,
  });

  factory MemberIdAndSubscriptionType.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MemberIdAndSubscriptionType();
    }

    String type = json['type'];
    SubscriptionType subscriptionType = type.toEnum(SubscriptionType.values);

    String state = json['state'];
    MemberStateType memberStateType = state.toEnum(MemberStateType.values);

    bool isNewebpay = false;
    if (json['subscription'] != null) {
      isNewebpay = true;
    }

    return MemberIdAndSubscriptionType(
      israfelId: json['id'],
      state: memberStateType,
      subscriptionType: subscriptionType,
      isNewebpay: isNewebpay,
    );
  }
}
