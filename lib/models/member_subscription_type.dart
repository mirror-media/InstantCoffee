import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/helpers/enum_parser.dart';

const List<SubscriptionType> premiumSubscriptionType = [
  SubscriptionType.marketing,
  SubscriptionType.subscribe_monthly,
  SubscriptionType.subscribe_yearly,
  SubscriptionType.marketing,
  SubscriptionType.staff,
];

enum SubscriptionType {
  @JsonValue('none')
  none,
  @JsonValue('marketing')
  marketing,
  @JsonValue('subscribe_one_time')
  subscribe_one_time,
  @JsonValue('subscribe_monthly') // ignore: constant_identifier_names
  subscribe_monthly,
  @JsonValue('subscribe_yearly') // ignore: constant_identifier_names
  subscribe_yearly,
  @JsonValue('subscribe_group') // ignore: constant_identifier_names
  subscribe_group,
  @JsonValue('staff') // ignore: constant_identifier_names
  staff
}

enum MemberStateType {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive
}

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
