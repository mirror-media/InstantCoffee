import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/subscriptionDetail.dart';

List<String> _kProductIds = <String>[
  Environment().config.monthSubscriptionId,
];

abstract class SubscriptionSelectRepos {
  Future<SubscriptionDetail> fetchSubscriptionDetail();
  Future<List<ProductDetails>> fetchProductDetailList();
  Future<bool> buySubscriptionProduct(PurchaseParam purchaseParam);
  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails);
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
  Future<SubscriptionDetail> fetchSubscriptionDetail() async{
    String firebaseId = _auth.currentUser.uid;
    String token = await _auth.currentUser.getIdToken();

    String query = """
    query fetchMemberSubscriptions(\$firebaseId: String!) {
      member(where: { firebaseId: \$firebaseId }) {
        subscription(
          orderBy: { createdAt: desc },
          where: {
            isActive: true
          },
          first: 1
        ) {
          frequency
          paymentMethod
          isCanceled
        }
        type
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

    SubscriptionDetail subscriptionDetail = SubscriptionDetail.fromJson(jsonResponse['data']);
    return subscriptionDetail;
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
  Future<bool> buySubscriptionProduct(PurchaseParam purchaseParam) async{
    bool buySuccess = false;

    try {
      buySuccess = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch(e) {
      print('buySubscriptionProduct' + e.toString());
    }
    
    return buySuccess;
  }

  @override
  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async{
    String token = await _auth.currentUser.getIdToken();

    String mutation = 
    """
    mutation (
      \$firebaseId: String!,
      \$packageName: String!,
      \$productId: String!, 
      \$source: upsertSubscriptionAppSourceType!,
      \$verificationData: String!
    ){
      upsertAppSubscription(
        info: {
          firebaseId: \$firebaseId
          packageName: \$packageName
          productId: \$productId
          source: \$source
          verificationData: \$verificationData
        }
      ) {
        success
      }
    }
    """;
    Map<String,String> variables = {
      "firebaseId" : _auth.currentUser.uid,
      "packageName" : Platform.isAndroid
          ? Environment().config.androidPackageName 
          : Environment().config.iOSBundleId,
      "productId" : purchaseDetails.productID,
      "source" : purchaseDetails.verificationData.source,
      "verificationData": purchaseDetails.verificationData.serverVerificationData,
    };

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: mutation,
      variables: variables,
    );

    try {
      final jsonResponse = await _helper.postByUrl(
        Environment().config.memberApi,
        jsonEncode(graphqlBody.toJson()),
        headers: getHeaders(token),
      );

      return !jsonResponse.containsKey('errors');
    } catch(e) {
      print(e);
      return false;
    }
  }
}
