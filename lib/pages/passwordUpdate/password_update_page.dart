import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/pages/passwordUpdate/password_update_widget.dart';
import 'package:readr_app/services/email_sign_in_service.dart';

class PasswordUpdatePage extends StatelessWidget {
  final bool isPremium;
  const PasswordUpdatePage({this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) =>
            PasswordUpdateBloc(emailSignInRepos: EmailSignInServices()),
        child: PasswordUpdateWidget(isPremium: isPremium),
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
