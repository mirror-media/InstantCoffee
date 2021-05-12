import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class PasswordUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Center(child: Text('修改密碼')),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('修改密碼'),
      backgroundColor: appColor,
    );
  }
}