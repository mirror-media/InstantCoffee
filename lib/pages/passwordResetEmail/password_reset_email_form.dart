import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/passwordResetEmail/bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/events.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/blocs/passwordResetEmail/states.dart';
import 'package:readr_app/pages/shared/sending_email_button.dart';

class PasswordResetEmailForm extends StatefulWidget {
  final String email;
  final PasswordResetEmailState state;
  const PasswordResetEmailForm({
    required this.email,
    required this.state,
  });

  @override
  _PasswordResetEmailFormState createState() => _PasswordResetEmailFormState();
}

class _PasswordResetEmailFormState extends State<PasswordResetEmailForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailEditingController = TextEditingController();
  bool _emailIsValid = false;

  @override
  void initState() {
    _emailEditingController.text = widget.email;
    _emailIsValid = _isEmailValid();
    _emailEditingController.addListener(() {
      setState(() {
        _emailIsValid = _isEmailValid();
      });
    });
    super.initState();
  }

  bool _isEmailValid() {
    RegExp regex = RegExp(validEmailPattern);
    return regex.hasMatch(_emailEditingController.text);
  }

  _sendPasswordResetEmail(String email) {
    context
        .read<PasswordResetEmailBloc>()
        .add(SendPasswordResetEmail(email: email));
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
        const SizedBox(height: 48),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '請輸入您註冊時使用的 Email 信箱。我們會發送一封 Email 到這個地址，裡面附有重設/設定密碼的連結。',
            style: TextStyle(fontSize: 17, color: Colors.black),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _emailTextField(),
        ),
        const SizedBox(height: 24),
        if (widget.state is PasswordResetEmailSendingFail) ...[
          const Center(
            child: Text(
              'Email 寄出失敗，請重新再試',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.state is EmailUserNotFound) ...[
          const Center(
            child: Text(
              '這個 Email 尚未註冊',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.state is PasswordResetEmailSending) ...[
          const Center(
            child: Text(
              '正在寄出信件...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff9B9B9B),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.state is PasswordResetEmailSendingSuccess) ...[
          const Center(
            child: Text(
              'Email 已成功寄出',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Center(
              child: Text(
                '沒收到信嗎？請檢查垃圾信件匣，或等候30秒重新寄送',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff9B9B9B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (widget.state is PasswordResetEmailSending)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _sendPasswordResetEmailLoadingButton(),
          ),
        if (widget.state is PasswordResetEmailInitState ||
            widget.state is PasswordResetEmailSendingFail ||
            widget.state is EmailUserNotFound ||
            widget.state is PasswordResetEmailSendingSuccess)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: SendingEmailButton(
              emailIsValid: _emailIsValid,
              isWaiting: widget.state is PasswordResetEmailSendingSuccess,
              onTap: () =>
                  _sendPasswordResetEmail(_emailEditingController.text),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  String? _validateEmail(String? value) {
    RegExp regex = RegExp(validEmailPattern);
    if (value == null || !regex.hasMatch(value)) {
      return '請輸入有效的 Email 地址';
    } else {
      return null;
    }
  }

  Widget _emailTextField() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: _validateEmail,
        controller: _emailEditingController,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          labelText: 'Email',
          contentPadding: const EdgeInsets.all(12.0),
          labelStyle: TextStyle(
            color: _emailIsValid ? Colors.black : Colors.red,
            fontSize: 16,
          ),
          errorStyle: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _sendPasswordResetEmailLoadingButton() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: const SpinKitThreeBounce(
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
