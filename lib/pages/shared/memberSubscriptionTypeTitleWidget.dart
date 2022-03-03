import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

class MemberSubscriptionTypeTitleWiget extends StatelessWidget {
  final SubscriptionType subscriptionType;
  final bool isCenter;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  MemberSubscriptionTypeTitleWiget({
    required this.subscriptionType,
    this.isCenter = false,
    this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    if(subscriptionType == SubscriptionType.none ||
      subscriptionType == SubscriptionType.subscribe_one_time
    ) {
      return Text(
        'Basic 會員',
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight
        ),
      );
    }

    if(subscriptionType == SubscriptionType.subscribe_monthly || 
      subscriptionType == SubscriptionType.subscribe_yearly
    ) {
      return Row(
        mainAxisAlignment: isCenter
            ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
            'Premium 會員',
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight
            ),
          ),
          SizedBox(width: 4),
          Image.asset(
            subscriptionIconPng,
            width: fontSize,
            height:fontSize,
          ),
        ],
      );
    }

    if(subscriptionType == SubscriptionType.staff){
      return Text(
        '鏡集團員工',
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight
        ),
      );
    }

    if(subscriptionType == SubscriptionType.subscribe_group){
      return Text(
        '團體訂閱',
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight
        ),
      );
    }

    // subscriptionType == SubscriptionType.marketing
    return Text(
      'VIP',
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight
      ),
    );
  }
}