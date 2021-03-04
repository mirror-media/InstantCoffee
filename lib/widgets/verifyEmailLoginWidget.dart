import 'package:flutter/material.dart';
import 'package:readr_app/blocs/loginBLoc.dart';

class VerifyEmailLoginWidget extends StatefulWidget {
  final LoginBloc loginBloc;
  VerifyEmailLoginWidget({
    @required this.loginBloc,
  });

  @override
  _VerifyEmailLoginWidgetState createState() => _VerifyEmailLoginWidgetState();
}

class _VerifyEmailLoginWidgetState extends State<VerifyEmailLoginWidget> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      widget.loginBloc.verifyEmail(context);
    });
    super.initState();
  }

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