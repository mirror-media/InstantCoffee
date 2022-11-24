import 'dart:convert';

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
  Map<String, dynamic>? get election {
    try {
      var election = jsonDecode(_remoteConfig.getString('election'));
      return {
        "api": election['api'] ??
            'https://whoareyou-gcs.readr.tw/elections/2022/mayor/special_municipality.json',
        "startTime": DateTime.parse(election['startTime']),
        "endTime": DateTime.parse(election['endTime']),
        "lookmoreUrl": election['lookmoreUrl'] ??
            'https://www.mirrormedia.mg/projects/election2022/index.html',
      };
    } catch (e) {
      print('Convert election json error: $e');
      return null;
    }
  }
}
