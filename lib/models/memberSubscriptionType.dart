import 'package:readr_app/helpers/EnumParser.dart';

enum SubscriptionType { 
  none, 
  marketing, 
  subscribe_one_time, 
  subscribe_monthly, 
  subscribe_yearly,
  subscribe_group,
  staff
}

enum MemberStateType { 
  active, 
  inactive
}

class MemberIdAndSubscriptionType {
  final String israfelId;
  final MemberStateType state;
  SubscriptionType subscriptionType;
  final bool isNewebpay;

  MemberIdAndSubscriptionType({
    this.israfelId,
    this.state,
    this.subscriptionType,
    this.isNewebpay,
  });

  factory MemberIdAndSubscriptionType.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return MemberIdAndSubscriptionType(
        israfelId: null,
        state: null,
        subscriptionType: SubscriptionType.none,
        isNewebpay: false,
      );
    }

    String type = json['type'];
    SubscriptionType subscriptionType = type.toEnum(SubscriptionType.values);

    String state = json['state'];
    MemberStateType memberStateType = state.toEnum(MemberStateType.values);

    bool isNewebpay = false;
    if(json['subscription'] != null){
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