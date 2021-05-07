import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class EmailLoginPage extends StatelessWidget {
  final String email;
  EmailLoginPage({
    @required this.email
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Center(child: Text(email),)
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('Email登入'),
      backgroundColor: appColor,
    );
  }
}