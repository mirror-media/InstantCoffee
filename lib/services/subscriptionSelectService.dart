import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/helpers/appException.dart';

const String _kMonthSubscriptionId = 'monthly';
const String _kYearSubscriptionId = 'yearly';
const List<String> _kProductIds = <String>[
  _kMonthSubscriptionId,
  _kYearSubscriptionId,
];

abstract class SubscriptionSelectRepos {
  Future<List<ProductDetails>> fetchProductDetailList();
  Future<bool> buySubscriptionProduct(PurchaseParam purchaseParam);
}

class SubscriptionSelectServices implements SubscriptionSelectRepos{
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  Future<List<ProductDetails>> fetchProductDetailList() async{
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if(isAvailable) {
      ProductDetailsResponse productDetailResponse = 
          await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
      return productDetailResponse.productDetails;
    }

    throw FetchDataException('The payment platform is unavailable');
  }


  @override
  Future<bool> buySubscriptionProduct(PurchaseParam purchaseParam) async{
    return await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }  
}
