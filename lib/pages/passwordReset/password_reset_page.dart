import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordReset/bloc.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/pages/passwordReset/password_reset_widget.dart';
import 'package:readr_app/services/email_sign_in_service.dart';

class PasswordResetPage extends StatelessWidget {
  final String code;
  const PasswordResetPage({
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) =>
            PasswordResetBloc(emailSignInRepos: EmailSignInServices()),
        child: PasswordResetWidget(
          code: code,
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
      title: const Text('修改密碼'),
      backgroundColor: appColor,
    );
  }
}
