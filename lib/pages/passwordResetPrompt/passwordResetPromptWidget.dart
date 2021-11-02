import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

class PasswordResetPromptWidget extends StatelessWidget {
  final String email;
  PasswordResetPromptWidget({
    @required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 48),
        Center(
          child: Text(
            '升級帳號安全性',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '為了提升帳號安全，從 4 月 28 日起，所有鏡週刊會員都需要以密碼登入。請您前往設定密碼，以繼續享受鏡週刊會員服務。',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _navigateToResetPasswordButton(context),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _navigateToResetPasswordButton(BuildContext context) {
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
            '前往設定密碼',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () {
        RouteGenerator.navigateToPasswordResetEmail(email: email);
      },
    );
  }
}