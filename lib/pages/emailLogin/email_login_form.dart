import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailLogin/bloc.dart';
import 'package:readr_app/blocs/emailLogin/events.dart';
import 'package:readr_app/blocs/emailLogin/states.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/pages/shared/password_form_field.dart';
import 'package:readr_app/pages/shared/password_validator_widget.dart';

class EmailLoginForm extends StatefulWidget {
  final String email;
  final EmailLoginState state;
  final TextEditingController passwordEditingController;
  const EmailLoginForm({
    required this.email,
    required this.state,
    required this.passwordEditingController,
  });

  @override
  _EmailLoginFormState createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  late TextEditingController _passwordEditingController;
  bool _passwordIsValid = false;

  @override
  void initState() {
    _passwordEditingController = widget.passwordEditingController;
    _passwordEditingController.addListener(() {
      setState(() {
        _passwordIsValid = _isPasswordValid();
      });
    });
    super.initState();
  }

  _signInWithEmailAndPassword(String email, String password) async {
    context
        .read<EmailLoginBloc>()
        .add(SignInWithEmailAndPassword(email: email, password: password));
  }

  bool _isPasswordValid() {
    return _passwordEditingController.text.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: PasswordFormField(
            title: '密碼',
            passwordEditingController: _passwordEditingController,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: PasswordValidatorWidget(
            editingController: _passwordEditingController,
          ),
        ),
        const SizedBox(height: 24),
        if (widget.state is EmailLoginFail) ...[
          const Center(
            child: Text(
              '密碼錯誤，請重新再試',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: widget.state is EmailLoginLoading
              ? _emailLoadingButton()
              : _loginButton(_passwordIsValid),
        ),
        const SizedBox(height: 24),
        Center(child: _forgetPasswordButton()),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _emailLoadingButton() {
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

  Widget _loginButton(bool emailAndPasswordIsValid) {
    return InkWell(
        borderRadius: BorderRadius.circular(5.0),
        onTap: emailAndPasswordIsValid
            ? () async {
                _signInWithEmailAndPassword(
                    widget.email, _passwordEditingController.text);
              }
            : null,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: emailAndPasswordIsValid ? appColor : const Color(0xffE3E3E3),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              '登入會員',
              style: TextStyle(
                  fontSize: 17,
                  color: emailAndPasswordIsValid ? Colors.white : Colors.grey),
            ),
          ),
        ));
  }

  Widget _forgetPasswordButton() {
    return InkWell(
      child: const Text(
        '忘記密碼',
        style: TextStyle(
          fontSize: 13,
          color: appColor,
        ),
      ),
      onTap: () =>
          RouteGenerator.navigateToPasswordResetEmail(email: widget.email),
    );
  }
}
