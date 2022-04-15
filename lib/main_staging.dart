import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/mirrorMediaApp.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  if (Platform.isIOS) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
  MobileAds.instance.initialize();
  Environment().initConfig(BuildFlavor.staging);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  runApp(MirrorMediaApp());
}