import 'package:flutter/material.dart';

class VerifyEmailLoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 72),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '驗證 Email 中',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '目前正在進行Email登入',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '請稍等',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }
}