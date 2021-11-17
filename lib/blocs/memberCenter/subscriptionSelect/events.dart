import 'package:in_app_purchase/in_app_purchase.dart';

abstract class SubscriptionSelectEvents{}

class FetchSubscriptionProducts extends SubscriptionSelectEvents {
  @override
  String toString() => 'FetchSubscriptionProducts';
}

class BuySubscriptionProduct extends SubscriptionSelectEvents {
  final PurchaseParam purchaseParam;
  BuySubscriptionProduct(
    this.purchaseParam,
  );

  @override
  String toString() => 'BuySubscriptionProduct { productId: ${purchaseParam.productDetails.id} }';
}