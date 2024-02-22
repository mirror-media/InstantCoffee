import 'package:flutter/material.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PasswordUpdateErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 48),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '抱歉，出了點狀況...',
              style: TextStyle(fontSize: 28),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '請重新嘗試更新密碼',
              style: TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '或是聯繫客服信箱',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: InkWell(
              child: const Text(
                mirrorMediaServiceEmail,
                style: TextStyle(color: appColor, fontSize: 16.0),
              ),
              onTap: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: mirrorMediaServiceEmail,
                );

                if (await canLaunchUrlString(emailLaunchUri.toString())) {
                  await launchUrlString(emailLaunchUri.toString());
                } else {
                  throw 'Could not launch $mirrorMediaServiceEmail';
                }
              }),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '或致電 (02)6633-3966 由專人為您服務。',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backButton(context),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Center(
            child: Text(
              '返回會員頁',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
        ),
        onTap: () => Navigator.of(context).pop());
  }
}
