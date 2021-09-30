import 'dart:io';

import 'package:package_info/package_info.dart';
import 'package:readr_app/models/appVersion.dart';
import 'package:readr_app/services/appVersionSerivce.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

class AppUpgradeHelper {
  bool needToUpdate = false;
  List<AppVersion> appVersionList = List.empty(growable: true);

  Future<bool> isUpdateAvailable() async{
    try {
      AppVersionService appVersionService = AppVersionService();
      appVersionList = await appVersionService.fetchMajorVersion();
      AppVersion appVersion = appVersionList.firstWhere((appVersion) => appVersion.platform.toLowerCase() == Platform.operatingSystem);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String version = packageInfo.version.toLowerCase();
      if(version.contains('dev')) {
        version = version.split(' ')[0];
      }

      final installedVersion = Version.parse(version);
      final appMajorVersion = Version.parse(appVersion.majorVersion);
      
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