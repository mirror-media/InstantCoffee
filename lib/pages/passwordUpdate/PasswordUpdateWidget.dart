import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberBloc.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/pages/passwordUpdate/oldPasswordConfirmForm.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdateErrorWidget.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdateForm.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdateSuccessWidget.dart';

class PasswordUpdateWidget extends StatefulWidget {
  final MemberBloc memberBloc;
  PasswordUpdateWidget({
    @required this.memberBloc,
  });

  @override
  _PasswordUpdateWidgetState createState() => _PasswordUpdateWidgetState();
}

class _PasswordUpdateWidgetState extends State<PasswordUpdateWidget> {
  void _delayNavigatorPop() async{
    await Future.delayed(Duration(milliseconds: 0));
    Navigator.of(context).pop();
  }

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
        if (state is PasswordUpdateSuccess) {
          widget.memberBloc.passwordUpdateSuccess = true;
          return PasswordUpdateSuccessWidget();
        }
        if (state is PasswordUpdateFail) {
          widget.memberBloc.passwordUpdateSuccess = false;
          _delayNavigatorPop();
        }

        // state is Password Update Init, Loading 
        return PasswordUpdateForm(
          passwordUpdateState: state,
        );
      }
    );
  }
}