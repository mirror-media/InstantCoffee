import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailLogin/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/emailLogin/signInWithEmailAndPasswordWidget.dart';
import 'package:readr_app/services/emailSignInService.dart';

class EmailLoginPage extends StatelessWidget {
  final String email;
  EmailLoginPage({
    required this.email
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => EmailLoginBloc(emailSignInRepos: EmailSignInServices()),
        child: SignInWithEmailAndPasswordWidget(email: email,),
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
      title: Text('Email登入'),
      backgroundColor: appColor,
    );
  }
}