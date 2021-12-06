import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

class AppUpgradeHelper {
  RemoteConfig _remoteConfig = RemoteConfig.instance;
  bool needToUpdate = false;
  String updateMessage = '';

  Future<bool> isUpdateAvailable() async{
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 1),
      ));
      await _remoteConfig.fetchAndActivate();
      String minAppVersion = _remoteConfig.getString('min_version_number');
      updateMessage = _remoteConfig.getString('update_message');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String version = packageInfo.version.toLowerCase();

      final installedVersion = Version.parse(version);
      final appMajorVersion = Version.parse(minAppVersion);
      
      return appMajorVersion > installedVersion;
    } catch(e) {
      print(e);
    }
    
    return false;
  }

  Future<String> getTrackViewUrl() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(Platform.isAndroid) {
      return await _getAndroidTrackViewUrl(packageInfo.packageName);
    } else if(Platform.isIOS) {
      return await _getIosTrackViewUrl(packageInfo.packageName);
    }

    return '';
  }

  /// Return app url on App store(iOS only).
  Future<String> _getIosTrackViewUrl(String packageName) async {
    Map iTunesResponse = await ITunesSearchAPI().lookupByBundleId(packageName);

    String value = "";
    try {
      value = iTunesResponse['results'][0]['trackViewUrl'];
    } catch (e) {
      print('upgradeHelper.ITunesResults.trackViewUrl: $e');
    }
    return value;
  }

  Future<String> _getAndroidTrackViewUrl(String packageName) async { 
    return "market://details?id=" + packageName;
  }
}