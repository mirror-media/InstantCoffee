import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

class AppUpgradeHelper with Logger {
  final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  bool needToUpdate = false;
  String updateMessage = '';

  Future<bool> isUpdateAvailable() async {
    try {
      String minAppVersion = _remoteConfigHelper.minAppVersion;
      updateMessage = _remoteConfigHelper.updateMessage;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String version = packageInfo.version.toLowerCase();

      final installedVersion = Version.parse(version);
      final appMajorVersion = Version.parse(minAppVersion);

      return appMajorVersion > installedVersion;
    } catch (e) {
      debugLog(e);
    }

    return false;
  }

  Future<String> getTrackViewUrl() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      return await _getAndroidTrackViewUrl(packageInfo.packageName);
    } else if (Platform.isIOS) {
      return await _getIosTrackViewUrl(packageInfo.packageName);
    }

    return '';
  }

  /// Return app url on App store(iOS only).
  Future<String> _getIosTrackViewUrl(String packageName) async {
    Map? iTunesResponse = await ITunesSearchAPI().lookupByBundleId(packageName);

    String value = "";
    try {
      value = iTunesResponse!['results'][0]['trackViewUrl'];
    } catch (e) {
      debugLog('upgradeHelper.ITunesResults.trackViewUrl: $e');
    }
    return value;
  }

  Future<String> _getAndroidTrackViewUrl(String packageName) async {
    return "market://details?id=$packageName";
  }
}
