import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/pages/login/loginWidget.dart';
import 'package:readr_app/services/loginService.dart';

class LoginPage extends StatelessWidget {
  final String routeName;
  final Object routeArguments;
  LoginPage({
    this.routeName = RouteGenerator.login,
    this.routeArguments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => LoginBloc(
          loginRepos: LoginServices(),
          
          routeName: routeName,
          routeArguments: routeArguments,
        ),
        child: LoginWidget()
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('會員中心'),
      backgroundColor: appColor,
    );
  }
}