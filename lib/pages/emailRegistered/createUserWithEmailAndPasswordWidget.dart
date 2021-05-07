import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailRegistered/bloc.dart';
import 'package:readr_app/blocs/emailRegistered/states.dart';
import 'package:readr_app/pages/emailRegistered/emailRegisteredErrorWidget.dart';
import 'package:readr_app/pages/emailRegistered/emailRegisteredForm.dart';
import 'package:readr_app/pages/emailRegistered/emailValidatorWidget.dart';
import 'package:readr_app/pages/emailRegistered/passwordValidatorWidget.dart';
import 'package:readr_app/widgets/memberLoginPolicy.dart';

class CreateUserWithEmailAndPasswordWidget extends StatefulWidget {
  final String email;
  CreateUserWithEmailAndPasswordWidget({
    @required this.email,
  });
    
  @override
  _CreateUserWithEmailAndPasswordWidgetState createState() => _CreateUserWithEmailAndPasswordWidgetState();
}

class _CreateUserWithEmailAndPasswordWidgetState extends State<CreateUserWithEmailAndPasswordWidget> {
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();

  void _delayNavigatorPop() async{
    await Future.delayed(Duration());
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<EmailRegisteredBloc, EmailRegisteredState>(
      builder: (BuildContext context, EmailRegisteredState state) {
        if (state is EmailRegisteredFail) {
          final error = state.error;
          print('EmailRegisteredFail: ${error.message}');
          return EmailRegisteredErrorWidget();
        }
        if (state is EmailRegisteredSuccess) {
          _delayNavigatorPop();
        }

        // state is Init, Loading, or EmailAlreadyInUse 
        return EmailRegisteredForm(
          email: widget.email,
          state: state,
          emailEditingController: _emailEditingController,
          passwordEditingController: _passwordEditingController,
        );
      }
    );
  }
}