import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/models/subscriptionDetail.dart';

enum SubscriptionSelectStatus { 
  initial, 
  loading, 
  loaded, 
  buying,
  buyingSuccess,
  error 
}

class SubscriptionSelectState {
  final SubscriptionSelectStatus status;
  final SubscriptionDetail subscriptionDetail;
  final List<ProductDetails> productDetailList;
  final dynamic errorMessages;

  const SubscriptionSelectState._({
    this.status,
    this.subscriptionDetail,
    this.productDetailList,
    this.errorMessages,
  });

  const SubscriptionSelectState.init()
      : this._(status: SubscriptionSelectStatus.initial);

  const SubscriptionSelectState.loading()
      : this._(status: SubscriptionSelectStatus.loading);

  const SubscriptionSelectState.loaded({
    SubscriptionDetail subscriptionDetail,
    List<ProductDetails> productDetailList,
  })  : this._(
        status: SubscriptionSelectStatus.loaded,
        subscriptionDetail: subscriptionDetail,
        productDetailList: productDetailList,
      );

  const SubscriptionSelectState.buying({
    SubscriptionDetail subscriptionDetail,
    List<ProductDetails> productDetailList,
  })  : this._(
        status: SubscriptionSelectStatus.buying,
        subscriptionDetail: subscriptionDetail,
        productDetailList: productDetailList,
      );

  const SubscriptionSelectState.buyingSuccess()
      : this._(status: SubscriptionSelectStatus.buyingSuccess);

  const SubscriptionSelectState.error({
    dynamic errorMessages
  })  : this._(
        status: SubscriptionSelectStatus.error,
        errorMessages: errorMessages,
      );
}