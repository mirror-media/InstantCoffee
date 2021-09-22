import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/emailVerification/bloc.dart';
import 'package:readr_app/blocs/emailVerification/events.dart';
import 'package:readr_app/blocs/emailVerification/states.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/shared/sendingEmailButton.dart';

class EmailVerificationForm extends StatefulWidget {
  final EmailVerificationState state;
  EmailVerificationForm({
    @required this.state
  });

  @override
  _EmailVerificationFormState createState() => _EmailVerificationFormState();
}

class _EmailVerificationFormState extends State<EmailVerificationForm> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailEditingController = TextEditingController();
  bool _emailIsValid = false;  

  @override
  void initState() {
    _emailEditingController.text = _auth.currentUser?.email;
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

  bool _isEmailReadOnly() {
    for(int i=0; i<_auth.currentUser.providerData.length; i++) {
      if(_auth.currentUser.providerData[i].providerId == 'password') {
        return true;
      }
    }
    return false;
  }

  _sendEmailVerification(String email, String redirectUrl) {
    context.read<EmailVerificationBloc>().add(
      SendEmailVerification(
        email: email,
        redirectUrl: redirectUrl
      )
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
       if(widget.state is SendingEmailVerificationFail || widget.state is EmailVerificationError )
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
        if(widget.state is SendingEmailVerification)
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
        if(widget.state is SendingEmailVerificationSuccess)
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

        if(widget.state is SendingEmailVerification)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _sendEmailLoadingButton(),
          ),
        if(widget.state is EmailVerificationInitState || 
        widget.state is SendingEmailVerificationFail ||
        widget.state is SendingEmailVerificationSuccess ||
        widget.state is EmailVerificationError)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: SendingEmailButton(
              emailIsValid: _emailIsValid,
              isWaiting: widget.state is SendingEmailVerificationSuccess,
              onTap: () => _sendEmailVerification(
                _emailEditingController.text, 
                env.baseConfig.finishEmailVerificationUrl + '?email=${_emailEditingController.text}'
              ),
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
    bool emailIsReadOnly = _isEmailReadOnly();

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        validator: _validateEmail,
        readOnly: emailIsReadOnly,
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
          border: emailIsReadOnly ? InputBorder.none : null,
          errorStyle: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _sendEmailLoadingButton() {
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