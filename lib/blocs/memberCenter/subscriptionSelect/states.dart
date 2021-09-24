import 'package:in_app_purchase/in_app_purchase.dart';

abstract class SubscriptionSelectState {}

class SubscriptionSelectInitState extends SubscriptionSelectState {}

class SubscriptionProductsLoading extends SubscriptionSelectState {}

class SubscriptionProductsLoaded extends SubscriptionSelectState {
  final List<ProductDetails> productDetailList;
  SubscriptionProductsLoaded({this.productDetailList});
}

class SubscriptionProductsLoadedFail extends SubscriptionSelectState {
  final error;
  SubscriptionProductsLoadedFail({this.error});
}