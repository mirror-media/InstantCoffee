import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/external_story_ad_mode.dart';
import 'package:readr_app/data/enum/page_status.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/share_helper.dart';
import 'package:readr_app/models/external_story.dart';
import 'package:readr_app/models/story_ad.dart';

class ExternalStoryController extends GetxController {
  final ArticlesApiProvider _articlesApiProvider = Get.find();

  final RxnString rxnSlug = RxnString();
  final RxBool rxIsPremium = false.obs;
  final Rxn<ExternalStory> rxExternalStory = Rxn();
  final Rx<PageStatus> rxPageStatus = Rx<PageStatus>(PageStatus.loading);
  final Rxn<StoryAd> rxnStoryAd = Rxn();
  final Rx<ExternalStoryAdMode> rxAdMod = Rx(ExternalStoryAdMode.other);

  ExternalStoryController({required String slug, required bool isMember}) {
    rxnSlug.value = slug;
    rxIsPremium.value = isMember;
  }

  @override
  void onInit() async {
    super.onInit();
    if (rxnSlug.value != null) {
      rxExternalStory.value = await _articlesApiProvider
          .getExternalArticleBySlug(slug: rxnSlug.value!);
      rxPageStatus.value = PageStatus.normal;
      loadAds();
    }
  }

  void loadAds() async {
    String storyAdJsonFileLocation = Platform.isIOS
        ? Environment().config.iOSStoryAdJsonLocation
        : Environment().config.androidStoryAdJsonLocation;
    String storyAdString = await rootBundle.loadString(storyAdJsonFileLocation);
    final storyAdMaps = json.decode(storyAdString);

    if (rxExternalStory.value != null) {
      final isShowOnIndex = rxExternalStory.value?.showOnIndex ?? false;
      rxAdMod.value =
          isShowOnIndex ? ExternalStoryAdMode.news : ExternalStoryAdMode.life;
    }
    rxnStoryAd.value = StoryAd.fromJson(storyAdMaps[rxAdMod.value.key]);
  }

  Future<void> shareStory({GlobalKey? shareButtonKey}) async {
    if (rxnSlug.value == null) return;

    String shareUrl =
        '${Environment().config.mirrorMediaDomain}/external/${rxnSlug.value}';

    await ShareHelper.shareWithPosition(
      text: shareUrl,
      buttonKey: shareButtonKey,
    );
  }
}
