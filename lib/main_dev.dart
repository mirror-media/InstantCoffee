import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/mirrorMediaApp.dart';

void main() async{
  // Inform the plugin that this app supports pending purchases on Android.
  // An error will occur on Android if you access the plugin `instance`
  // without this call.
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  Environment().initConfig(BuildFlavor.development);
  
  runApp(MirrorMediaApp());
}