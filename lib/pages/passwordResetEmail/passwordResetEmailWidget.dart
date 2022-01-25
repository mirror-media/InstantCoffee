import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/states.dart';
import 'package:readr_app/pages/passwordResetEmail/passwordResetEmailForm.dart';

class PasswordResetEmailWidget extends StatefulWidget {
  final String email;
  PasswordResetEmailWidget({
    required this.email,
  });

  @override
  _PasswordResetEmailWidgetState createState() => _PasswordResetEmailWidgetState();
}

class _PasswordResetEmailWidgetState extends State<PasswordResetEmailWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetEmailBloc, PasswordResetEmailState>(
      builder: (BuildContext context, PasswordResetEmailState state) {
        // state is Init, Sending, SendingSuccess, SendingFail, Error 
        return PasswordResetEmailForm(
          email: widget.email,
          state: state,
        );
      }
    );
  }
}