import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordReset/bloc.dart';
import 'package:readr_app/blocs/passwordReset/states.dart';
import 'package:readr_app/pages/passwordReset/passwordResetErrorWidget.dart';
import 'package:readr_app/pages/passwordReset/passwordResetForm.dart';
import 'package:readr_app/pages/passwordReset/passwordResetSuccessWidget.dart';

class PasswordResetWidget extends StatefulWidget {
  final String code;
  PasswordResetWidget({
    @required this.code,
  });

  @override
  _PasswordResetWidgetState createState() => _PasswordResetWidgetState();
}

class _PasswordResetWidgetState extends State<PasswordResetWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetBloc, PasswordResetState>(
      builder: (BuildContext context, PasswordResetState state) {
        if (state is PasswordResetError) {
          final error = state.error;
          print('EmailLoginError: ${error.message}');
          return PasswordResetErrorWidget();
        }
        if (state is PasswordResetSuccess) {
          return PasswordResetSuccessWidget();
        }

        // state is Init, Loading, or Fail 
        return PasswordResetForm(
          code: widget.code,
          state: state,
        );
      }
    );
  }
}