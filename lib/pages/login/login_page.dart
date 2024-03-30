import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/pages/login/login_widget.dart';
import 'package:readr_app/routes/routes.dart';
import 'package:readr_app/services/login_service.dart';

class LoginPage extends StatelessWidget {
  final String? routeName;
  final Map? routeArguments;

  const LoginPage({
    this.routeName,
    this.routeArguments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
          create: (context) => LoginBloc(
                loginRepos: LoginServices(),
                memberBloc: context.read<MemberBloc>(),
                routeName: routeName,
                routeArguments: routeArguments,
              ),
          child: LoginWidget()),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      title: const Text('會員中心'),
      backgroundColor: appColor,
    );
  }
}
