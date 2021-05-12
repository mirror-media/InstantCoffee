import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailLogin/bloc.dart';
import 'package:readr_app/blocs/emailLogin/events.dart';
import 'package:readr_app/blocs/emailLogin/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/pages/shared/passwordValidatorWidget.dart';

class EmailLoginForm extends StatefulWidget {
  final String email;
  final EmailLoginState state;
  final TextEditingController passwordEditingController;
  EmailLoginForm({
    @required this.email,
    @required this.state,
    @required this.passwordEditingController,
  });

  @override
  _EmailLoginFormState createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  TextEditingController _passwordEditingController;
  bool _isHidden = true;
  bool _passwordIsValid = false;

  @override
  void initState() {
    _passwordEditingController = widget.passwordEditingController;
    _passwordEditingController.addListener(
      () {
        setState(() {
          _passwordIsValid = _isPasswordValid();
        });
      }
    );
    super.initState();
  }

  _signInWithEmailAndPassword(String email, String password) async {
    context.read<EmailLoginBloc>().add(
      SignInWithEmailAndPassword(email: email, password: password)
    );
  }

  bool _isPasswordValid() {
    return _passwordEditingController.text != null && _passwordEditingController.text.length >= 6;
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _passwordField(),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: PasswordValidatorWidget(editingController: _passwordEditingController,),
        ),
        SizedBox(height: 24),
        if(widget.state is EmailLoginFail)
        ...[
          Center(
            child: Text(
              '密碼錯誤，請重新再試',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: widget.state is EmailLoginLoading
          ? _emailLoadingButton()
          : _loginButton(_passwordIsValid),
        ),
        SizedBox(height: 24),
        Center(child: _forgetPasswordButton()),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _passwordField() {
    return Form(
      child: TextFormField(
        controller: _passwordEditingController,
        obscureText: _isHidden,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => _togglePasswordView(),
            icon: _isHidden 
            ? Icon(Icons.visibility)
            : Icon(Icons.visibility_off),
          ),
          labelText: '設定密碼',
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
  
  Widget _emailLoadingButton() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SpinKitThreeBounce(color: Colors.white, size: 35,),
    );
  }
  
  Widget _loginButton(bool emailAndPasswordIsValid) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: emailAndPasswordIsValid
          ? appColor
          : Color(0xffE3E3E3),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            '登入會員',
            style: TextStyle(
              fontSize: 17,
              color: emailAndPasswordIsValid
              ? Colors.white
              : Colors.grey
            ),
          ),
        ),
      ),
      onTap: emailAndPasswordIsValid
      ? () async{
          _signInWithEmailAndPassword(
            widget.email, 
            _passwordEditingController.text
          );
        }
      : null
    );
  }

  Widget _forgetPasswordButton() {
    return InkWell(
      child: Text(
        '忘記密碼',
        style: TextStyle(
          fontSize: 13,
          color: appColor,
        ),
      ),
      onTap: () => RouteGenerator.navigateToPasswordResetEmail(
        context, 
        email: widget.email
      ),
    );
  }
}