import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/graphqlBody.dart';

List<String> _kProductIds = <String>[
  Environment().config.monthSubscriptionId,
  Environment().config.yearSubscriptionId,
];

abstract class SubscriptionSelectRepos {
  Future<List<ProductDetails>> fetchProductDetailList();
  Future<PurchaseDetails> fetchAndroidSubscriptionDetail();
  Future<bool> buySubscriptionProduct(PurchaseParam purchaseParam);
}

class SubscriptionSelectServices implements SubscriptionSelectRepos{
  final ApiBaseHelper _helper = ApiBaseHelper();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String,String> getHeaders(String token) {
    Map<String,String> headers = {
      "Content-Type": "application/json",
    };
    if(token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }

    return headers;
  }

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
  Future<PurchaseDetails> fetchAndroidSubscriptionDetail() async{
    String firebaseId = _auth.currentUser.uid;
    String token = await _auth.currentUser.getIdToken();

    String query = """
    query fetchMemberSubscriptions(\$firebaseId: String!) {
      member(where: { firebaseId: \$firebaseId }) {
        subscription(
          orderBy: { createdAt: desc },
          where: {
            isActive: true,
            paymentMethod: google_play
          },
          first: 1
        ) {
          frequency
          googlePlayPurchaseToken
          paymentMethod
        }
      }
    }
    """;
    Map<String, String> variables = {"firebaseId": "$firebaseId"};
    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    PurchaseDetails purchaseDetails = PurchaseDetails(
      productID: jsonResponse['data']['member']['subscription'][0]['frequency'],
      verificationData: PurchaseVerificationData(
        localVerificationData: '',
        serverVerificationData: jsonResponse['data']['member']['subscription'][0]['googlePlayPurchaseToken'],
        source: '',
      ),
      transactionDate: '',
      status: PurchaseStatus.purchased,
    );

    return purchaseDetails;
  }  


  @override
  Future<bool> buySubscriptionProduct(PurchaseParam purchaseParam) async{
    bool buySuccess = false;

    try {
      buySuccess = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch(e) {
      print('buySubscriptionProduct' + e.toString());
    }
    
    return buySuccess;
  }
}
