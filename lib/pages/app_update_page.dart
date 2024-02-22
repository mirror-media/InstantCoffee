import 'package:flutter/material.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/helpers/app_upgrade_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppUpdatePage extends StatelessWidget with Logger {
  final AppUpgradeHelper appUpgradeHelper;
  const AppUpdatePage({
    required this.appUpgradeHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          centerTitle: true,
          title: const Text(appTitle),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 48),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  '更新通知',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  appUpgradeHelper.updateMessage,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: _updateButton(context),
              ),
            ),
          ],
        ));
  }

  _updateButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Center(
          child: Text(
            '立即更新',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () async {
        String trackViewUrl = await appUpgradeHelper.getTrackViewUrl();
        if (await canLaunchUrlString(trackViewUrl)) {
          try {
            await launchUrlString(trackViewUrl);
          } catch (e) {
            debugLog('upgrader: launch to app store failed: $e');
          }
        }
      },
    );
  }
}
