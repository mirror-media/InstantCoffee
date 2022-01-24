import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailRegistered/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/emailRegistered/createUserWithEmailAndPasswordWidget.dart';
import 'package:readr_app/services/emailSignInService.dart';

class EmailRegisteredPage extends StatelessWidget {
  final String email;
  EmailRegisteredPage({
    required this.email
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => EmailRegisteredBloc(emailSignInRepos: EmailSignInServices()),
        child: CreateUserWithEmailAndPasswordWidget(email: email,),
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
      title: Text('Email註冊'),
      backgroundColor: appColor,
    );
  }
}