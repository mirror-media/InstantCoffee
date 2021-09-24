import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/services/subscriptionSelectService.dart';

abstract class SubscriptionSelectEvents{
  Stream<SubscriptionSelectState> run(SubscriptionSelectRepos subscriptionSelectRepos);
}

class FetchSubscriptionProducts extends SubscriptionSelectEvents {
  @override
  String toString() => 'FetchSubscriptionProducts';

  @override
  Stream<SubscriptionSelectState> run(SubscriptionSelectRepos subscriptionSelectRepos) async*{
    print(this.toString());
    try{
      yield SubscriptionProductsLoading();
      List<ProductDetails> productDetailList = await subscriptionSelectRepos.fetchProductDetailList();
      yield SubscriptionProductsLoaded(
        productDetailList: productDetailList,
      );
    } on SocketException {
      yield SubscriptionProductsLoadedFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield SubscriptionProductsLoadedFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield SubscriptionProductsLoadedFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield SubscriptionProductsLoadedFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}