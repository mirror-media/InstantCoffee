import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/pages/passwordUpdate/old_password_confirm_form.dart';
import 'package:readr_app/pages/passwordUpdate/password_update_error_widget.dart';
import 'package:readr_app/pages/passwordUpdate/password_update_form.dart';
import 'package:readr_app/pages/passwordUpdate/password_update_success_widget.dart';
import 'package:readr_app/widgets/logger.dart';

class PasswordUpdateWidget extends StatefulWidget {
  final bool isPremium;
  const PasswordUpdateWidget({required this.isPremium});

  @override
  _PasswordUpdateWidgetState createState() => _PasswordUpdateWidgetState();
}

class _PasswordUpdateWidgetState extends State<PasswordUpdateWidget>
    with Logger {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordUpdateBloc, PasswordUpdateState>(
        listener: (BuildContext context, PasswordUpdateState state) async {
      if (state is PasswordUpdateSuccess) {
        if (widget.isPremium) {
          FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signOut();
          context.read<MemberBloc>().add(UpdateSubscriptionType(
              isLogin: false, israfelId: null, subscriptionType: null));
        } else {
          context.read<LoginBloc>().add(SignOut());
        }
      }
    }, builder: (BuildContext context, PasswordUpdateState state) {
      if (state is PasswordUpdateError) {
        final error = state.error;
        debugLog('EmailLoginError: ${error.message}');
        return PasswordUpdateErrorWidget();
      }
      if (state is OldPasswordConfirm) {
        return OldPasswordConfirmForm(
          oldPasswordConfirm: state,
        );
      }
      if (state is PasswordUpdateSuccess) {
        return PasswordUpdateSuccessWidget();
      }

      // state is Password Update Init, Loading
      return PasswordUpdateForm(
        passwordUpdateState: state,
      );
    });
  }
}
