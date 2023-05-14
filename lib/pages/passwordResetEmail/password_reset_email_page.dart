import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/passwordResetEmail/password_reset_email_widget.dart';
import 'package:readr_app/services/email_sign_in_service.dart';

class PasswordResetEmailPage extends StatelessWidget {
  final String email;
  const PasswordResetEmailPage({
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) =>
            PasswordResetEmailBloc(emailSignInRepos: EmailSignInServices()),
        child: PasswordResetEmailWidget(email: email),
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
      title: const Text('設定/重設密碼'),
      backgroundColor: appColor,
    );
  }
}
