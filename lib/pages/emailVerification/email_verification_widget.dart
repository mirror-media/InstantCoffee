import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailVerification/bloc.dart';
import 'package:readr_app/blocs/emailVerification/states.dart';
import 'package:readr_app/pages/emailVerification/email_verification_form.dart';

class EmailVerificationWidget extends StatefulWidget {
  @override
  _EmailVerificationWidgetState createState() =>
      _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
        builder: (BuildContext context, EmailVerificationState state) {
      // state is Init, Sending, SendingSuccess, SendingFail, Error
      return EmailVerificationForm(
        state: state,
      );
    });
  }
}
