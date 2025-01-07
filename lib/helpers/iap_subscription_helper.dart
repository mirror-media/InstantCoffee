import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/services/subscription_select_service.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:device_info_plus/device_info_plus.dart';

class IAPSubscriptionHelper {
  static final IAPSubscriptionHelper _instance =
      IAPSubscriptionHelper._internal();

  factory IAPSubscriptionHelper() {
    return _instance;
  }

  IAPSubscriptionHelper._internal();

  bool verifyPurchaseInBloc = false;
  StreamController<PurchaseDetails> buyingPurchaseController =
      StreamController<PurchaseDetails>.broadcast();
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<void> handleIncompletePurchases() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        SKPaymentQueueWrapper skPaymentQueueWrapper = SKPaymentQueueWrapper();
        List<SKPaymentTransactionWrapper> transactions =
            await skPaymentQueueWrapper.transactions();
        List<SKPaymentTransactionWrapper> purchasedTransactions = [];
        for (var skPaymentTransactionWrapper in transactions) {
          if (skPaymentTransactionWrapper.transactionState ==
              SKPaymentTransactionStateWrapper.purchased) {
            purchasedTransactions.add(skPaymentTransactionWrapper);
          }
        }
        String receiptData = await getReceiptData();
        List<PurchaseDetails> purchaseDetails = purchasedTransactions
            .map((SKPaymentTransactionWrapper transaction) =>
                AppStorePurchaseDetails.fromSKTransaction(
                    transaction, receiptData))
            .toList();
        for (var purchaseDetail in purchaseDetails) {
          verifyEntirePurchase(purchaseDetail);
        }
      }
    } else if (Platform.isAndroid) {
      _inAppPurchase.restorePurchases();
    }
  }

  Future<String> getReceiptData() async {
    String receiptData;
    try {
      receiptData = await SKReceiptManager.retrieveReceiptData();
    } catch (e) {
      receiptData = '';
    }
    return receiptData;
  }

  void setSubscription() async {
    await _inAppPurchase.isAvailable();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    handleIncompletePurchases();
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (verifyPurchaseInBloc) {
        buyingPurchaseController.sink.add(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            if (purchaseDetails.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(purchaseDetails);
            }
          } else {
            _handleInvalidPurchase(purchaseDetails);
            continue;
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          if (Platform.isIOS) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          if (Platform.isAndroid) {
            if (purchaseDetails.pendingCompletePurchase) {
              verifyEntirePurchase(purchaseDetails);
            }
          }
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    SubscriptionSelectServices subscriptionSelectServices =
        SubscriptionSelectServices();
    return await subscriptionSelectServices.verifyPurchase(purchaseDetails);
  }

  Future<bool> _handleInvalidPurchase(PurchaseDetails purchaseDetails) async {
    int retryAwaitSecond = 1;
    int retryMaxAwaitSecond = 60;
    bool valid = false;
    while (!valid && retryAwaitSecond < retryMaxAwaitSecond) {
      await Future.delayed(Duration(seconds: retryAwaitSecond));
      valid = await _verifyPurchase(purchaseDetails);
      if (valid) {
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
      retryAwaitSecond = retryAwaitSecond * 2;
    }

    return valid;
  }

  Future<void> completePurchase(PurchaseDetails purchaseDetails) async {
    await _inAppPurchase.completePurchase(purchaseDetails);
  }

  Future<bool> verifyEntirePurchase(PurchaseDetails purchaseDetails) async {
    bool valid = await _verifyPurchase(purchaseDetails);
    if (valid) {
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    } else {
       valid = await _handleInvalidPurchase(purchaseDetails);
    }

    return valid;
  }

  cancelSubscriptionStream() {
    _subscription.cancel();
    buyingPurchaseController.close();
  }
}
