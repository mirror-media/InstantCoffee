import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/deletMemberWidget.dart';

class DeleteMemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: DeleteMemberWidget(),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop()
      ),
      centerTitle: true,
      title: Text('會員中心'),
      backgroundColor: appColor,
    );
  }
}