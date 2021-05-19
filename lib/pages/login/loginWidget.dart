import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/pages/login/loginErrorWidget.dart';
import 'package:readr_app/pages/login/loginForm.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  void initState() {
    _checkIsLoginOrNot();
    super.initState();
  }
  
  _checkIsLoginOrNot() {
    context.read<LoginBloc>().add(
      CheckIsLoginOrNot()
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (BuildContext context, LoginState state) {
        if(state is LoadingUI) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is LoginFail) {
          final error = state.error;
          print('EmailLoginError: ${error.message}');
          return LoginErrorWidget();
        }
        if (state is LoginSuccess) {
          return Center(child: Text('Login sucessfully.'));
        }

        // state is Init, Third Party Loading
        return LoginForm(
          state: state,
        );
      }
    );
  }
}