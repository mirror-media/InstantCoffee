import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailVerification/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/emailVerification/email_verification_widget.dart';
import 'package:readr_app/services/email_sign_in_service.dart';

class EmailVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) =>
            EmailVerificationBloc(emailSignInRepos: EmailSignInServices()),
        child: EmailVerificationWidget(),
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
      title: const Text('驗證信箱'),
      backgroundColor: appColor,
    );
  }
}
