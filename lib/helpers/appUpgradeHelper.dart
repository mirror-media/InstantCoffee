import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class AppUpgradeHelper {
  Map _iTunesResponse;

  Future<bool> isUpdateAvailable() async{
    if(Platform.isAndroid) {
      return await isAndroidUpdateAvailable();
    }
    else if(Platform.isIOS) {
      return await isIOSUpdateAvailable();
    }

    return false;
  }

  Future<bool> isAndroidUpdateAvailable() async{
    try {
      AppUpdateInfo androidVersion = await InAppUpdate.checkForUpdate();
      return androidVersion.updateAvailable;
    }catch(e) {
      print(e);
    }
    
    return false;
  }

  Future<bool> isIOSUpdateAvailable() async{
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final iTunesVersion = await _getITunesVersion(packageInfo.packageName);

      final installedVersion = Version.parse(packageInfo.version);
      final appStoreVersion = Version.parse(iTunesVersion);

      return installedVersion < appStoreVersion;
    }catch(e) {
      print(e);
    }
    
    return false;
  }

  /// Return field version on App store(iOS only).
  Future<String> _getITunesVersion(String packageName) async{
    _iTunesResponse = _iTunesResponse ?? await ITunesSearchAPI().lookupByBundleId(packageName);

    String value;
    try {
      value = _iTunesResponse['results'][0]['version'];
    } catch (e) {
      print('upgradeHelper.ITunesResults.version: $e');
    }
    return value == null ? '0.0.0' : value;
  }

  /// Return app url on App store(iOS only).
  Future<String> _getTrackViewUrl(String packageName) async{
    _iTunesResponse = _iTunesResponse ?? await ITunesSearchAPI().lookupByBundleId(packageName);

    String value;
    try {
      value = _iTunesResponse['results'][0]['trackViewUrl'];
    } catch (e) {
      print('upgradeHelper.ITunesResults.trackViewUrl: $e');
    }
    return value;
  }

  /// Return app name on App store(iOS only).
  Future<String> _getAppName(String packageName) async{
    _iTunesResponse = _iTunesResponse ?? await ITunesSearchAPI().lookupByBundleId(packageName);

    String value;
    try {
      value = _iTunesResponse['results'][0]['trackCensoredName'];
    } catch (e) {
      print('upgradeHelper.ITunesResults.appName: $e');
    }
    return value;
  }

  void renderUpgradeUI(BuildContext context) {
    if(Platform.isAndroid) {
      renderAndroidUpgradeUI();
    }
    else if(Platform.isIOS) {
      renderIOSUpgradeUI(context);
    }
  }

  void renderAndroidUpgradeUI() async{
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      print('android upgrade error: $e');
    }
  }

  void renderIOSUpgradeUI(BuildContext context) async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String iTunesAppUrl = await _getTrackViewUrl(packageInfo.packageName);
    String appName = await _getAppName(packageInfo.packageName);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('要更新「$appName」嗎?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$appName 最新版本已發佈'),

            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('下次'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('更新'),
                onPressed: () async{
                  if (await canLaunch(iTunesAppUrl)) {
                    try {
                      await launch(iTunesAppUrl);
                    } catch (e) {
                      print('upgrader: launch to app store failed: $e');
                    }
                  } else {}
                  Navigator.of(context).pop();
                }
            )
          ],
        );
      },
    );
  }
}