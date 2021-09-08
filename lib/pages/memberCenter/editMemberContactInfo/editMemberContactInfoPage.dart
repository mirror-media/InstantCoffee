import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/editMemberContactInfoWidget.dart';
import 'package:readr_app/services/memberService.dart';

class EditMemberContactInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => EditMemberContactInfoBloc(memberRepos: MemberService()),
        child: EditMemberContactInfoWidget(),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColor,
      centerTitle: true,
      titleSpacing: 0.0,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: Text(
              '取消',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text('修改聯絡資訊'),
          TextButton(
            child: Text(
              '儲存',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}