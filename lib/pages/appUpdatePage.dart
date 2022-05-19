import 'package:flutter/material.dart';
import 'package:readr_app/helpers/appUpgradeHelper.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppUpdatePage extends StatelessWidget {
  final AppUpgradeHelper appUpgradeHelper;
  AppUpdatePage({
    required this.appUpgradeHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          centerTitle: true,
          title: Text(appTitle),
        ),
        body: ListView(
          children: [
            SizedBox(height: 48),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  '更新通知',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  appUpgradeHelper.updateMessage,
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
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
        child: Center(
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
            print('upgrader: launch to app store failed: $e');
          }
        }
      },
    );
  }
}
