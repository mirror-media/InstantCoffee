import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/pages/passwordUpdate/oldPasswordConfirmForm.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdateErrorWidget.dart';

class PasswordUpdateWidget extends StatefulWidget {
  @override
  _PasswordUpdateWidgetState createState() => _PasswordUpdateWidgetState();
}

class _PasswordUpdateWidgetState extends State<PasswordUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordUpdateBloc, PasswordUpdateState>(
      builder: (BuildContext context, PasswordUpdateState state) {
        if (state is PasswordUpdateError) {
          final error = state.error;
          print('EmailLoginError: ${error.message}');
          return PasswordUpdateErrorWidget();
        }
        if (state is OldPasswordConfirm) {
          return OldPasswordConfirmForm(
            oldPasswordConfirm: state,
          );
        }

        // state is Password Update Init, Loading, or Fail 
        return Container();
      }
    );
  }
}