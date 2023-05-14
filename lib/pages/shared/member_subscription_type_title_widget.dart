import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/models/member_subscription_type.dart';

class MemberSubscriptionTypeTitleWiget extends StatelessWidget {
  final SubscriptionType subscriptionType;
  final bool isCenter;
  final TextStyle? textStyle;
  final Color? premiumIconColor;
  const MemberSubscriptionTypeTitleWiget(
      {required this.subscriptionType,
      this.isCenter = false,
      this.textStyle,
      this.premiumIconColor});

  @override
  Widget build(BuildContext context) {
    if (subscriptionType == SubscriptionType.none ||
        subscriptionType == SubscriptionType.subscribe_one_time) {
      return Text('Basic 會員', style: textStyle);
    }

    if (subscriptionType == SubscriptionType.subscribe_monthly ||
        subscriptionType == SubscriptionType.subscribe_yearly) {
      return Row(
        mainAxisAlignment:
            isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text('Premium 會員', style: textStyle),
          const SizedBox(width: 4),
          Image.asset(
            subscriptionIconPng,
            width: textStyle?.fontSize ?? 14,
            height: textStyle?.fontSize ?? 14,
            color: premiumIconColor,
          ),
        ],
      );
    }

    if (subscriptionType == SubscriptionType.staff) {
      return Text('鏡集團員工', style: textStyle);
    }

    if (subscriptionType == SubscriptionType.subscribe_group) {
      return Text('團體訂閱', style: textStyle);
    }

    // subscriptionType == SubscriptionType.marketing
    return Text('VIP', style: textStyle);
  }
}
