import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

class LoginPage extends StatelessWidget {
  final String routeName;
  final Object routeArguments;
  LoginPage({
    this.routeName = RouteGenerator.magazine,
    this.routeArguments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(),
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