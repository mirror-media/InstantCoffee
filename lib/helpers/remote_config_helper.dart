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

  String get minAppVersion => _remoteConfig.getString('min_version_number');

  String get updateMessage => _remoteConfig.getString('update_message');

  bool get isNewsMarqueePin => _remoteConfig.getBool('news_marquee_pin');

  bool get hasTabSectionButton => _remoteConfig.getBool('tab_section_button');

  bool get isElectionShow => _remoteConfig.getBool('isElectionShow');

  bool get isSubscriptShow => _remoteConfig.getBool('isSubscriptShow');

  bool get isAnonymousShow => _remoteConfig.getBool('isAnonymousShow');

  double get textScale => _remoteConfig.getDouble('text_scale');

  bool get isIosSubscriptEnable =>
      _remoteConfig.getBool('isIosSubscriptEnable');

  bool get isNoticeDialogEnabled =>
      _remoteConfig.getBool('notice_dialog_enabled');

  String get noticeDialogTitle =>
      _remoteConfig.getString('notice_dialog_title');

  String get noticeDialogContent =>
      _remoteConfig.getString('notice_dialog_content');

  String get noticeDialogVersion =>
      _remoteConfig.getString('notice_dialog_version');
}
