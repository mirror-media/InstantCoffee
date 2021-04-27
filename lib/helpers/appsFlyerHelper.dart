import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

class AppsFlyerHelper {
  static AppsFlyerHelper _instance;

  final AppsFlyerOptions _options = AppsFlyerOptions(
    afDevKey: env.baseConfig.appsFlyerKey, 
    appId: Platform.isIOS 
    ? env.baseConfig.appleAppId 
    : env.baseConfig.androidAppId, 
    showDebug: false
  );
  AppsflyerSdk _appsflyerSdk;

  AppsFlyerHelper._internal() {
    _appsflyerSdk = AppsflyerSdk(_options);
    _instance = this;
  }
  
  factory AppsFlyerHelper() => _instance ?? AppsFlyerHelper._internal();

  Future<void> initialAppsFlyer(BuildContext context) async{
    var k = await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true
    );
    _appsflyerSdk.appOpenAttributionStream.listen(
      (event) {
        print('-----OpenAttribution-----');
        print(event);
        print('-------------------------');

        if(event['data']['slug'] != null) {
          RouteGenerator.navigateToStory(context, event['data']['slug'], isListeningWidget: false);
        }
      }
    );
    _appsflyerSdk.conversionDataStream.listen(
      (event) {
        print('-----ConversionData-----');
        print(event);
        print('------------------------');
        if(event['data']['is_first_launch']) {
          if(event['data']['slug'] != null) {
            RouteGenerator.navigateToStory(context, event['data']['slug'], isListeningWidget: false);
          }
        }
      }
    );
    print(k);
  }
}