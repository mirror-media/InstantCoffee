import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailRegistered/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/emailRegistered/create_user_with_email_and_password_widget.dart';
import 'package:readr_app/services/email_sign_in_service.dart';

class EmailRegisteredPage extends StatelessWidget {
  final String email;
  const EmailRegisteredPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) =>
            EmailRegisteredBloc(emailSignInRepos: EmailSignInServices()),
        child: CreateUserWithEmailAndPasswordWidget(
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
      title: const Text('Email註冊'),
      backgroundColor: appColor,
    );
  }
}
