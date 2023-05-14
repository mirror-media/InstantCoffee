import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 72),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '登入失敗',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '請重新登入，或是聯繫客服',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        InkWell(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  'E-MAIL: $mirrorMediaServiceEmail',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
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
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '(02)6633-3966',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '我們將有專人為您服務',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backToHomeButton(context),
        ),
      ],
    );
  }

  Widget _backToHomeButton(BuildContext context) {
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
            '回首頁',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}
