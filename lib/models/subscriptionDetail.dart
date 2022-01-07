import 'package:readr_app/helpers/EnumParser.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/models/paymentRecord.dart';

class SubscriptionDetail {
  final SubscriptionType subscriptionType;
  final PaymentType paymentType;
  final bool isAutoRenewing;

  SubscriptionDetail({
    this.subscriptionType,
    this.paymentType,
    this.isAutoRenewing,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    String subscriptionTypeJson = json['member']['type'];
    SubscriptionType subscriptionType = subscriptionTypeJson.toEnum(SubscriptionType.values);

    PaymentType paymentType;
    bool isAutoRenewing = false;

    if(json['member']['subscription'] != null) {
      String paymentMethodJson = json['member']['subscription'][0]['paymentMethod'];
      paymentType = paymentMethodJson.toEnum(PaymentType.values);

      isAutoRenewing = !json['member']['subscription'][0]['isCanceled'];
    }
    
    return SubscriptionDetail(
      subscriptionType: subscriptionType,
      paymentType: paymentType,
      isAutoRenewing: isAutoRenewing,
    );
  }
}