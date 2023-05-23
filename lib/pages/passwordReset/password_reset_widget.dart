import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordReset/bloc.dart';
import 'package:readr_app/blocs/passwordReset/states.dart';
import 'package:readr_app/pages/passwordReset/password_reset_error_widget.dart';
import 'package:readr_app/pages/passwordReset/password_reset_form.dart';
import 'package:readr_app/pages/passwordReset/password_reset_success_widget.dart';
import 'package:readr_app/widgets/logger.dart';

class PasswordResetWidget extends StatefulWidget {
  final String code;
  const PasswordResetWidget({
    required this.code,
  });

  @override
  _PasswordResetWidgetState createState() => _PasswordResetWidgetState();
}

class _PasswordResetWidgetState extends State<PasswordResetWidget> with Logger {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordResetBloc, PasswordResetState>(
        builder: (BuildContext context, PasswordResetState state) {
      if (state is PasswordResetError) {
        final error = state.error;
        debugLog('EmailLoginError: ${error.message}');
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
    });
  }
}
