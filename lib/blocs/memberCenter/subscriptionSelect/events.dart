import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

abstract class SubscriptionSelectEvents{}

class FetchSubscriptionProducts extends SubscriptionSelectEvents {
  final SubscritionType subscritionType;
  FetchSubscriptionProducts(
    this.subscritionType,
  );

  @override
  String toString() => 'FetchSubscriptionProducts { subscritionType: ${subscritionType.toString()} }';
}

class BuySubscriptionProduct extends SubscriptionSelectEvents {
  final PurchaseParam purchaseParam;
  BuySubscriptionProduct(
    this.purchaseParam,
  );

  @override
  String toString() => 'BuySubscriptionProduct { productId: ${purchaseParam.productDetails.id} }';
}

class BuyingPurchaseStatusChanged extends SubscriptionSelectEvents {
  final PurchaseDetails purchaseDetails;
  BuyingPurchaseStatusChanged(
    this.purchaseDetails,
  );

  @override
  String toString() => 'BuyingPurchaseStatusChanged { status: ${purchaseDetails.status} }';
}