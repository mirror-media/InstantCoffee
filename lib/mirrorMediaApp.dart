import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/services/subscriptionSelectService.dart';

StreamSubscription<List<PurchaseDetails>> subscription;
StreamController<PurchaseDetails> buyingPurchaseController = StreamController<PurchaseDetails>.broadcast();

class MirrorMediaApp extends StatefulWidget {
  @override
  State<MirrorMediaApp> createState() => _MirrorMediaAppState();
}

class _MirrorMediaAppState extends State<MirrorMediaApp> {
  InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  void initState() {
    subscription = _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    super.initState();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      buyingPurchaseController.sink.add(purchaseDetails);
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          if(purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        } else {
          //_handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      else if (purchaseDetails.status == PurchaseStatus.canceled) {
        if(Platform.isIOS) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async{
    SubscriptionSelectServices subscriptionSelectServices = SubscriptionSelectServices();
    return subscriptionSelectServices.verifyPurchase(purchaseDetails);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // force portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp(
      navigatorKey: RouteGenerator.navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('zh', 'TW'), // Traditional Chinese
        // ... other locales the app supports
      ],
      title: appTitle,
      theme: ThemeData(
        primaryColor: appColor,
      ),
      initialRoute: RouteGenerator.root,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}