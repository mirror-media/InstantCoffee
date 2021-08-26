import 'package:flutter/material.dart';
import 'package:readr_app/pages/shared/sendingEmailButton.dart';

class EmailVerificationWidget extends StatefulWidget {
  @override
  _EmailVerificationWidgetState createState() => _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailEditingController = TextEditingController();
  bool _emailIsValid = false;

  @override
  void initState() {
    _emailIsValid = _isEmailValid();
    _emailEditingController.addListener(
      () {
        setState(() {
          _emailIsValid = _isEmailValid();
        });
      }
    );
    super.initState();
  }

  bool _isEmailValid() {
    Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regex = RegExp(pattern);
    return _emailEditingController.text != null && regex.hasMatch(_emailEditingController.text);
  }
  
  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text('您的帳號尚未完成 Email 驗證，請輸入可用來接收驗證信的 Email 信箱。'),
        ),
        SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text('這個 Email 將會自動綁定您目前的帳號。'),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _emailTextField(),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: SendingEmailButton(
            emailIsValid: _emailIsValid,
            isWaiting: false,
            onTap: () => print(_emailEditingController.text),
          ),
        ),
      ],
    );
  }

  String _validateEmail(String value) {
    Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return '請輸入有效的 Email 地址';
    else
      return null;
  }

  Widget _emailTextField() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: _validateEmail,
        controller: _emailEditingController,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          labelText: 'Email',
          contentPadding: EdgeInsets.all(12.0),
          labelStyle: TextStyle(
            color: _emailIsValid? Colors.black : Colors.red ,
            fontSize: 16,
          ),
          errorStyle: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}