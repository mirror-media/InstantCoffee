import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailLogin/bloc.dart';
import 'package:readr_app/blocs/emailLogin/states.dart';
import 'package:readr_app/pages/emailLogin/email_login_error_widget.dart';
import 'package:readr_app/pages/emailLogin/email_login_form.dart';
import 'package:readr_app/widgets/logger.dart';

class SignInWithEmailAndPasswordWidget extends StatefulWidget {
  final String email;
  const SignInWithEmailAndPasswordWidget({required this.email});

  @override
  _SignInWithEmailAndPasswordWidgetState createState() =>
      _SignInWithEmailAndPasswordWidgetState();
}

class _SignInWithEmailAndPasswordWidgetState
    extends State<SignInWithEmailAndPasswordWidget> with Logger {
  final _passwordEditingController = TextEditingController();

  void _delayNavigatorPop() async {
    await Future.delayed(const Duration(milliseconds: 0));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailLoginBloc, EmailLoginState>(
        builder: (BuildContext context, EmailLoginState state) {
      if (state is EmailLoginError) {
        final error = state.error;
        debugLog('EmailLoginError: ${error.message}');
        return EmailLoginErrorWidget();
      }
      if (state is EmailLoginSuccess) {
        _delayNavigatorPop();
      }

      // state is Init, Loading, or Fail
      return EmailLoginForm(
          email: widget.email,
          state: state,
          passwordEditingController: _passwordEditingController);
    });
  }
}
