import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/passwordResetEmail/bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/events.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/blocs/passwordResetEmail/states.dart';
import 'package:readr_app/pages/shared/sendingEmailButton.dart';

class PasswordResetEmailForm extends StatefulWidget {
  final String email;
  final PasswordResetEmailState state;
  PasswordResetEmailForm({
    @required this.email,
    @required this.state,
  });

  @override
  _PasswordResetEmailFormState createState() => _PasswordResetEmailFormState();
}

class _PasswordResetEmailFormState extends State<PasswordResetEmailForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailEditingController = TextEditingController();
  bool _emailIsValid = false;

  @override
  void initState() {
    _emailEditingController.text = widget.email;
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

  _sendPasswordResetEmail(String email) {
    context.read<PasswordResetEmailBloc>().add(
      SendPasswordResetEmail(email: email)
    );
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
          child: Text(
            '請輸入您註冊時使用的 Email 信箱。我們會發送一封 Email 到這個地址，裡面附有重設/設定密碼的連結。',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _emailTextField(),
        ),
        SizedBox(height: 24),
        if(widget.state is PasswordResetEmailSendingFail)
        ...[
          Center(
            child: Text(
              'Email 寄出失敗，請重新再試',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
        if(widget.state is EmailUserNotFound)
        ...[
          Center(
            child: Text(
              '這個 Email 尚未註冊',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
        if(widget.state is PasswordResetEmailSending)
        ...[
          Center(
            child: Text(
              '正在寄出信件...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff9B9B9B),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
        if(widget.state is PasswordResetEmailSendingSuccess)
        ...[
          Center(
            child: Text(
              'Email 已成功寄出',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
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
          SizedBox(height: 12),
        ],
        if(widget.state is PasswordResetEmailSending)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _sendPasswordResetEmailLoadingButton(),
          ),
        if(widget.state is PasswordResetEmailInitState || 
        widget.state is PasswordResetEmailSendingFail ||
        widget.state is EmailUserNotFound ||
        widget.state is PasswordResetEmailSendingSuccess)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: SendingEmailButton(
              emailIsValid: _emailIsValid,
              isWaiting: widget.state is PasswordResetEmailSendingSuccess,
              onTap: () => _sendPasswordResetEmail(_emailEditingController.text),
            ),
          ),
        SizedBox(height: 24),
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
  
  Widget _sendPasswordResetEmailLoadingButton() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SpinKitThreeBounce(color: Colors.white, size: 35,),
    );
  }
}