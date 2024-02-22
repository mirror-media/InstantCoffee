import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailLogin/bloc.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/pages/emailLogin/sign_in_with_email_and_password_widget.dart';
import 'package:readr_app/services/email_sign_in_service.dart';

class EmailLoginPage extends StatelessWidget {
  final String email;

  const EmailLoginPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) =>
            EmailLoginBloc(emailSignInRepos: EmailSignInServices()),
        child: SignInWithEmailAndPasswordWidget(
          email: email,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text('Email登入'),
      backgroundColor: appColor,
    );
  }
}
