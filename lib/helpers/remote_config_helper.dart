import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:readr_app/widgets/logger.dart';

class RemoteConfigHelper with Logger {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<bool> initialize({
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(seconds: 10),
  }) async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval));

    return await _remoteConfig.fetchAndActivate();
  }

  Future<bool> refresh({
    Duration fetchTimeout = const Duration(seconds: 5),
  }) async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: fetchTimeout, minimumFetchInterval: Duration.zero));

      return await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugLog('RemoteConfig refresh error: $e');
      return false;
    }
  }

  String get minAppVersion => _remoteConfig.getString('min_version_number');

  String get updateMessage => _remoteConfig.getString('update_message');

  bool get isNewsMarqueePin => _remoteConfig.getBool('news_marquee_pin');

  bool get hasTabSectionButton => _remoteConfig.getBool('tab_section_button');

  bool get isElectionShow => _remoteConfig.getBool('isElectionShow');

  bool get isAnonymousShow => _remoteConfig.getBool('isAnonymousShow');

  bool get isTopIframeShow => _remoteConfig.getBool('isTopIframeShow');

  String get topIframeUrl => _remoteConfig.getString('topIframeUrl');

  String get iframeTitle => _remoteConfig.getString('iframeTitle');

  String get iframeShowMoreUrl => _remoteConfig.getString('iframeShowMoreUrl');

  double get textScale => _remoteConfig.getDouble('text_scale');

  bool get isIosSubEnabled => _remoteConfig.getBool('isIosSubEnabled');

  bool get isAndroidSubEnabled => _remoteConfig.getBool('isAndroidSubEnabled');

  String get subNoticeTitle => _remoteConfig.getString('subNoticeTitle');

  String get subNoticeContent => _remoteConfig.getString('subNoticeContent');

  String get subNoticeConfirmTitle =>
      _remoteConfig.getString('subNoticeConfirmTitle');

  String get subNoticeConfirmURL =>
      _remoteConfig.getString('subNoticeConfirmURL');

  String get subNoticeCancelTitle =>
      _remoteConfig.getString('subNoticeCancelTitle');

  bool get isNoticeDialogEnabled =>
      _remoteConfig.getBool('notice_dialog_enabled');

  String get noticeDialogTitle =>
      _remoteConfig.getString('notice_dialog_title');

  String get noticeDialogContent =>
      _remoteConfig.getString('notice_dialog_content');

  String get noticeDialogVersion =>
      _remoteConfig.getString('notice_dialog_version');

  bool get isFreePremium => _remoteConfig.getBool('isFreePremium');
}
