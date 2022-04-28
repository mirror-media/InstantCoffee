import 'dart:io';
import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/helpers/environment.dart';

class AdHelper {
  static final AdHelper _singleton = AdHelper._internal();

  factory AdHelper() {
    return _singleton;
  }

  int _clickCount = 0;

  AdHelper._internal();

  void checkToShowInterstitialAd() async{
    _clickCount++;
    if(_clickCount%3 == 0) {
      String interstitialAdUnitId = Platform.isIOS
      ? Environment().config.iOSInterstitialAdUnitId
      : Environment().config.androidInterstitialAdUnitId;

      InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            ad.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error');
          },
        )
      );
    }
  }
}