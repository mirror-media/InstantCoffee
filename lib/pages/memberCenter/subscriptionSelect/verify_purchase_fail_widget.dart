import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VerifyPurchaseFailWidget extends StatelessWidget {
  final ButtonStyle buttonStyle = TextButton.styleFrom(
    backgroundColor: appColor,
    padding: const EdgeInsets.only(top: 12, bottom: 12),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 48.0),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '我們已收到您的款項，目前正在處理中，請稍待數分鐘。',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '若仍無法正常觀看會員文章，請',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '聯繫會員專屬客服信箱',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      mirrorMediaServiceEmail,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: mirrorMediaServiceEmail,
                      );

                      if (await canLaunchUrlString(emailLaunchUri.toString())) {
                        await launchUrlString(emailLaunchUri.toString());
                      } else {
                        throw 'Could not launch $mirrorMediaServiceEmail';
                      }
                    },
                  ),
                ],
              )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '或來電客服專線 (02)6633-3966',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '我們會盡快為您協助處理。',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: OutlinedButton(
            style: buttonStyle,
            child: const Center(
              child: Text(
                '回首頁',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
      ],
    );
  }
}
