import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/pages/login/login_page.dart';

class EmailVerificationSuccessPage extends StatelessWidget {
  final String email;
  EmailVerificationSuccessPage({
    required this.email,
  });
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: _buildContent(context),
    );
  }

  bool _isLoggedIn() {
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text('驗證信箱'),
      backgroundColor: appColor,
    );
  }

  Widget _buildContent(BuildContext context) {
    String contentText;
    String buttonText;
    if (!_isLoggedIn()) {
      contentText = '$email 已驗證成功！\n請重新登入，繼續完成訂購流程。';
      buttonText = '重新登入';
    } else if (email == _auth.currentUser!.email) {
      contentText = '$email 已驗證成功！';
      buttonText = '繼續前往付款';
    } else {
      contentText =
          '$email 已驗證成功！\n\n提醒您，此裝置目前登入帳號為：\n${_auth.currentUser!.email}';
      buttonText = '換個帳號重新登入';
    }
    return Column(
      children: [
        const SizedBox(height: 48),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '驗證成功',
              style: TextStyle(fontSize: 28),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              contentText,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _loginButton(context, buttonText),
      ],
    );
  }

  Widget _loginButton(BuildContext context, String buttonText) {
    return InkWell(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 50.0,
          margin: const EdgeInsets.symmetric(horizontal: 67.5),
          decoration: BoxDecoration(
            color: appColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onTap: () async {
          if (!_isLoggedIn()) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          } else if (email == _auth.currentUser!.email) {
            RouteGenerator.navigateToSubscriptionSelect(
                usePushReplacement: true);
          } else {
            await _auth.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        });
  }
}
