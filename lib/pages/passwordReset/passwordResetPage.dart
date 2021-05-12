import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordReset/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/passwordReset/passwordResetWidget.dart';
import 'package:readr_app/services/emailSignInService.dart';

class PasswordResetPage extends StatelessWidget {
  final String code;
  PasswordResetPage({
    @required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => PasswordResetBloc(emailSignInRepos: EmailSignInServices()),
        child: PasswordResetWidget(
          code: code,
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('修改密碼'),
      backgroundColor: appColor,
    );
  }
}