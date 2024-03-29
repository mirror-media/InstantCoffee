import 'package:readr_app/helpers/enum_parser.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/models/payment_record.dart';

class SubscriptionDetail {
  final SubscriptionType subscriptionType;
  final PaymentType? paymentType;
  final bool? isAutoRenewing;

  SubscriptionDetail({
    required this.subscriptionType,
    required this.paymentType,
    required this.isAutoRenewing,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    String subscriptionTypeJson = json['member']['type'];
    SubscriptionType subscriptionType =
        subscriptionTypeJson.toEnum(SubscriptionType.values);

    PaymentType? paymentType;
    bool? isAutoRenewing;

    if (json['member']['subscription'] != null) {
      String paymentMethodJson =
          json['member']['subscription'][0]['paymentMethod'];
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
