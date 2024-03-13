import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/section_ad.dart';

class AdHelper {
  static final AdHelper _singleton = AdHelper._internal();

  factory AdHelper() {
    return _singleton;
  }

  int _clickCount = 0;

  AdHelper._internal();

  void checkToShowInterstitialAd() async {
    _clickCount++;
    if (_clickCount % 3 == 0) {
      String interstitialAdUnitId = Platform.isIOS
          ? Environment().config.iOSInterstitialAdUnitId
          : Environment().config.androidInterstitialAdUnitId;

      InterstitialAd.load(
          adUnitId: interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              ad.show();
            },
            onAdFailedToLoad: (LoadAdError error) {
              log('InterstitialAd failed to load: $error');
            },
          ));
    }
  }

  Future<SectionAd?> getSectionAdBySlug(String? slug) async {
    String sectionAdJsonFileLocation = Platform.isIOS
        ? Environment().config.iOSSectionAdJsonLocation
        : Environment().config.androidSectionAdJsonLocation;

    String sectionAdString =
        await rootBundle.loadString(sectionAdJsonFileLocation);
    final sectionAdMaps = json.decode(sectionAdString) as Map<String, dynamic>;
    return sectionAdMaps.containsKey(slug)
        ? SectionAd.fromJson(sectionAdMaps[slug])
        : SectionAd.fromJson(sectionAdMaps['other']);
  }
}
