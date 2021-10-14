import 'package:readr_app/helpers/apiConstants.dart' as prod;
import 'package:readr_app/helpers/devApiConstants.dart' as dev;

class BaseConfig {
  final bool isDev;
  BaseConfig({
    this.isDev = false,
  });

  String get mirrorMediaDomain => isDev ? dev.mirrorMediaDomain : prod.mirrorMediaDomain;

  String get apiBase => isDev ? dev.apiBase : prod.apiBase;
  String get storyPageApi => isDev ? dev.storyPageApi : prod.storyPageApi;
  String get memberApi => isDev ? dev.memberApi : prod.memberApi;
  String get tokenStateApi => isDev ? dev.tokenStateApi : prod.tokenStateApi;

  String get mirrorMediaNotImageUrl =>
      isDev ? dev.mirrorMediaNotImageUrl : prod.mirrorMediaNotImageUrl;
  String get latestAPI => isDev ? dev.latestAPI : prod.latestAPI;
  String get sectionAPI => isDev ? dev.sectionAPI : prod.sectionAPI;
  String get listingBase => isDev ? dev.listingBase : prod.listingBase;

  String get listeningWidgetApi =>
      isDev ? dev.listeningWidgetApi : prod.listeningWidgetApi;

  String get newsMarqueeApi => isDev ? dev.newsMarqueeApi : prod.newsMarqueeApi;
  String get editorChoiceApi =>
      isDev ? dev.editorChoiceApi : prod.editorChoiceApi;

  String get listingBaseSearchByPersonAndFoodSection => isDev
      ? dev.listingBaseSearchByPersonAndFoodSection
      : prod.listingBaseSearchByPersonAndFoodSection;
  String get popularListAPI => isDev ? dev.popularListAPI : prod.popularListAPI;

  String get searchApi => isDev ? dev.searchApi : prod.searchApi;

  String get magazinesApi => isDev ? dev.magazinesApi : prod.magazinesApi;

  String get personalSectionKey =>
      isDev ? dev.personalSectionKey : prod.personalSectionKey;
  String get wineSectionKey => isDev ? dev.wineSectionKey : prod.wineSectionKey;
  String get wine1SectionKey =>
      isDev ? dev.wine1SectionKey : prod.wine1SectionKey;
  String get listeningSectionKey =>
      isDev ? dev.listeningSectionKey : prod.listeningSectionKey;
  String get memberSectionKey =>
      isDev ? dev.memberSectionKey : prod.memberSectionKey;
  String get focusSectionKey =>
      isDev ? dev.focusSectionKey : prod.focusSectionKey;

  String get appleAppId => isDev ? dev.appleAppId : prod.appleAppId;
  String get androidAppId => isDev ? dev.androidAppId : prod.androidAppId;

  String get iOSBundleId => isDev ? dev.iOSBundleId : prod.iOSBundleId;
  String get androidPackageName =>
      isDev ? dev.androidPackageName : prod.androidPackageName;

  String get recoverPasswordUrl =>
      isDev ? dev.recoverPasswordUrl : prod.recoverPasswordUrl;
  String get finishEmailVerificationUrl =>
      isDev ? dev.finishEmailVerificationUrl : prod.finishEmailVerificationUrl;
  String get dynamicLinkDomain =>
      isDev ? dev.dynamicLinkDomain : prod.dynamicLinkDomain;

  String get iOSSectionAdJsonLocation =>
      isDev ? dev.iOSSectionAdJsonLocation : prod.iOSSectionAdJsonLocation;
  String get androidSectionAdJsonLocation => isDev
      ? dev.androidSectionAdJsonLocation
      : prod.androidSectionAdJsonLocation;
  String get iOSStoryAdJsonLocation =>
      isDev ? dev.iOSStoryAdJsonLocation : prod.iOSStoryAdJsonLocation;
  String get androidStoryAdJsonLocation =>
      isDev ? dev.androidStoryAdJsonLocation : prod.androidStoryAdJsonLocation;

  String get appsFlyerKey => isDev ? dev.appsFlyerKey : prod.appsFlyerKey;
  String get firebaseApiKey => isDev ? dev.firebaseApiKey : prod.firebaseApiKey;

  String get appVersionApi => isDev ? dev.appVersionApi : prod.appVersionApi;
}
