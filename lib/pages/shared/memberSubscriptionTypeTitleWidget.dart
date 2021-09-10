import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

class MemberSubscriptionTypeTitleWiget extends StatelessWidget {
  final SubscritionType subscritionType;
  final double fontSize;
  MemberSubscriptionTypeTitleWiget({
    @required this.subscritionType,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    if(subscritionType == SubscritionType.none) {
      return Text(
        'Basic 會員',
        style: TextStyle(
          fontSize: fontSize,
        ),
      );
    }

    if(subscritionType == SubscritionType.monthly_subscriber || 
      subscritionType == SubscritionType.yearly_subscriber
    ) {
      return Row(
        children: [
          Text(
            'Premium 會員',
            style: TextStyle(
              fontSize: fontSize,
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

    // subscritionType == SubscritionType.marketing
    return Text(
      'VIP',
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}