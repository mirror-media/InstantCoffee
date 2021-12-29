import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/helpers/EnumParser.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/src/billing_client_wrappers/purchase_wrapper.dart';
import 'package:readr_app/models/paymentRecord.dart';

class SubscriptionDetail {
  final SubscriptionType subscriptionType;
  final PaymentType paymentType;
  final bool isAutoRenewing;
  final GooglePlayPurchaseDetails googlePlayPurchaseDetails;

  SubscriptionDetail({
    this.subscriptionType,
    this.paymentType,
    this.isAutoRenewing,
    this.googlePlayPurchaseDetails,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    String subscriptionTypeJson = json['member']['type'];
    SubscriptionType subscriptionType = subscriptionTypeJson.toEnum(SubscriptionType.values);

    PaymentType paymentType;
    bool isAutoRenewing = false;
    GooglePlayPurchaseDetails googlePlayPurchaseDetails;

    if(json['member']['subscription'] != null) {
      String paymentMethodJson = json['member']['subscription'][0]['paymentMethod'];
      paymentType = paymentMethodJson.toEnum(PaymentType.values);

      isAutoRenewing = !json['member']['subscription'][0]['isCanceled'];

      
      if(paymentType == PaymentType.google_play) {
        googlePlayPurchaseDetails = GooglePlayPurchaseDetails(
          productID: json['member']['subscription'][0]['frequency'],
          purchaseID: '',
          verificationData: PurchaseVerificationData(
            localVerificationData: '',
            serverVerificationData: json['member']['subscription'][0]['googlePlayPurchaseToken'],
            source: '',
          ),
          transactionDate: '',
          billingClientPurchase: PurchaseWrapper(
            sku: json['member']['subscription'][0]['frequency'],
            purchaseToken: json['member']['subscription'][0]['googlePlayPurchaseToken'],
            purchaseState: PurchaseStateWrapper.purchased,
            packageName: Environment().config.androidPackageName,
            isAcknowledged: true,
            isAutoRenewing: isAutoRenewing,
          ),
          status: PurchaseStatus.purchased,
        );
      }
    }

    
    return SubscriptionDetail(
      subscriptionType: subscriptionType,
      paymentType: paymentType,
      isAutoRenewing: isAutoRenewing,
      googlePlayPurchaseDetails: googlePlayPurchaseDetails
    );
  }
}