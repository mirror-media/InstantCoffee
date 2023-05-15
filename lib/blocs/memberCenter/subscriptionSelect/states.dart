import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/models/subscription_detail.dart';

enum SubscriptionSelectStatus {
  initial,
  loading,
  loaded,
  buying,
  buyingSuccess,
  verifyPurchaseFail,
  error
}

class SubscriptionSelectState {
  final SubscriptionSelectStatus status;
  final SubscriptionDetail? subscriptionDetail;
  final List<ProductDetails>? productDetailList;
  final String? storySlug;
  final dynamic errorMessages;

  const SubscriptionSelectState._({
    required this.status,
    this.subscriptionDetail,
    this.productDetailList,
    this.storySlug,
    this.errorMessages,
  });

  const SubscriptionSelectState.init()
      : this._(status: SubscriptionSelectStatus.initial);

  const SubscriptionSelectState.loading()
      : this._(status: SubscriptionSelectStatus.loading);

  const SubscriptionSelectState.loaded({
    required SubscriptionDetail subscriptionDetail,
    required List<ProductDetails> productDetailList,
  }) : this._(
          status: SubscriptionSelectStatus.loaded,
          subscriptionDetail: subscriptionDetail,
          productDetailList: productDetailList,
        );

  const SubscriptionSelectState.buying({
    required SubscriptionDetail subscriptionDetail,
    required List<ProductDetails> productDetailList,
  }) : this._(
          status: SubscriptionSelectStatus.buying,
          subscriptionDetail: subscriptionDetail,
          productDetailList: productDetailList,
        );

  const SubscriptionSelectState.buyingSuccess({
    String? storySlug,
  }) : this._(
            status: SubscriptionSelectStatus.buyingSuccess,
            storySlug: storySlug);

  const SubscriptionSelectState.verifyPurchaseFail()
      : this._(status: SubscriptionSelectStatus.verifyPurchaseFail);

  const SubscriptionSelectState.error({dynamic errorMessages})
      : this._(
          status: SubscriptionSelectStatus.error,
          errorMessages: errorMessages,
        );
}
