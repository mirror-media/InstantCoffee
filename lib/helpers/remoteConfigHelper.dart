import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigHelper {
  FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<bool> initialize({
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(hours: 1),
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
  String get electionApi => _remoteConfig.getString('election_api');
}
