import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/passwordResetEmail/passwordResetEmailWidget.dart';
import 'package:readr_app/services/emailSignInService.dart';

class PasswordResetEmailPage extends StatelessWidget {
  final String email;
  PasswordResetEmailPage({
    required this.email,
  });
  
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => PasswordResetEmailBloc(emailSignInRepos: EmailSignInServices()),
        child: PasswordResetEmailWidget(email: email),
      ),
    );
  }
  
  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('設定/重設密碼'),
      backgroundColor: appColor,
    );
  }
}