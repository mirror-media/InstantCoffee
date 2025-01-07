import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/app_exception.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/graphql_body.dart';
import 'package:readr_app/models/payment_record.dart';
import 'package:readr_app/models/subscription_detail.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

List<String> _kProductIds = <String>[
  Environment().config.monthSubscriptionId,
];

abstract class SubscriptionSelectRepos {
  Future<SubscriptionDetail> fetchSubscriptionDetail();

  Future<List<ProductDetails>> fetchProductDetailList();

  Future<bool> buySubscriptionProduct(
      PurchaseParam purchaseParam, ProductDetails productDetails);

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails);
}

class SubscriptionSelectServices
    with Logger
    implements SubscriptionSelectRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<SubscriptionDetail> fetchSubscriptionDetail() async {
    String? firebaseId = _auth.currentUser?.uid;
    String? token = await _auth.currentUser?.getIdToken();

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
      headers: MemberService.getHeaders(token),
    );

    SubscriptionDetail subscriptionDetail =
        SubscriptionDetail.fromJson(jsonResponse['data']);
    return subscriptionDetail;
  }

  @override
  Future<List<ProductDetails>> fetchProductDetailList() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (isAvailable) {
      ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
      return productDetailResponse.productDetails;
    }

    throw FetchDataException('The payment platform is unavailable');
  }

  Future<bool> hasPendingTransaction(String productId) async {
    bool hasPendingTransaction = false;

    InAppPurchase.instance.purchaseStream.listen((purchases) {
      for (var purchase in purchases) {
        if (purchase.productID == productId &&
            purchase.pendingCompletePurchase) {
          hasPendingTransaction = true;
        }
      }
    }).onError((error) {
      print("購買流監聽錯誤: $error");
    });

    return hasPendingTransaction;
  }

  @override
  Future<bool> buySubscriptionProduct(
      PurchaseParam purchaseParam, ProductDetails productDetails) async {
    bool buySuccess = false;

    final purchaseParam = PurchaseParam(productDetails: productDetails);

    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (var transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
      }
    }

    try {
      buySuccess =
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugLog('buySubscriptionProduct$e');
    }

    return buySuccess;
  }

  @override
  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    if (_auth.currentUser == null) {
      return false;
    }
    if (purchaseDetails.verificationData.source == PaymentType.app_store.name) {
      return await _verifyPurchaseByIos(purchaseDetails);
    }
    return await _verifyPurchaseByAndroid(purchaseDetails);
  }

  Future<bool> _verifyPurchaseByAndroid(PurchaseDetails purchaseDetails) async {
    String firebaseId = _auth.currentUser!.uid;
    String? token = await _auth.currentUser!.getIdToken();

    Map<String, String> bodyMap = {
      "firebaseId": firebaseId,
      "packageName": Platform.isAndroid
          ? Environment().config.androidPackageName
          : Environment().config.iOSBundleId,
      "subscriptionId": purchaseDetails.productID,
      "purchaseToken": purchaseDetails.verificationData.serverVerificationData
    };

    try {
      final jsonResponse = await _helper.postByUrl(
        Environment().config.verifyAndroidPurchaseApi,
        jsonEncode(bodyMap),
        headers: MemberService.getHeaders(token),
      );

      return jsonResponse.containsKey('status') &&
          jsonResponse['status'] == 'success';
    } catch (e) {
      debugLog(e);
      return false;
    }
  }

  Future<bool> _verifyPurchaseByIos(PurchaseDetails purchaseDetails) async {
    String firebaseId = _auth.currentUser!.uid;
    String? token = await _auth.currentUser!.getIdToken();

    Map<String, String> bodyMap = {
      "firebaseId": firebaseId,
      "receiptData": purchaseDetails.verificationData.serverVerificationData
    };

    try {
      final jsonResponse = await _helper.postByUrl(
        Environment().config.verifyIosPurchaseApi,
        jsonEncode(bodyMap),
        headers: MemberService.getHeaders(token),
      );

      return jsonResponse.containsKey('success') &&
          jsonResponse['success'] == true;
    } catch (e) {
      debugLog(e);
      return false;
    }
  }
}
