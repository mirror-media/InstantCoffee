import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class PasswordResetPage extends StatelessWidget {
  final String code;
  PasswordResetPage({
    @required this.code,
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
      title: Text('更改密碼'),
      backgroundColor: appColor,
    );
  }
}