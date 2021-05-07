import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailLoginErrorWidget extends StatefulWidget {
  @override
  _EmailLoginErrorWidgetState createState() => _EmailLoginErrorWidgetState();
}

class _EmailLoginErrorWidgetState extends State<EmailLoginErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '抱歉，出了點狀況...',
              style: TextStyle(
                fontSize: 28
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '請重新嘗試登入',
              style: TextStyle(
                fontSize: 28
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '或是聯繫客服信箱',
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: InkWell(
            child: Text(
              'mm-onlineservice@mirrormedia.mg',
              style: TextStyle(color: appColor, fontSize: 16.0),
            ),
            onTap: () async{
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'mm-onlineservice@mirrormedia.mg',
              );

              if (await canLaunch(emailLaunchUri.toString())) {
                await launch(emailLaunchUri.toString());
              } else {
                throw 'Could not launch mm-onlineservice@mirrormedia.mg';
              }
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '或致電 (02)6633-3966 由專人為您服務。',
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backButton(),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _backButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            '返回註冊',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pop()
    );
  }
}