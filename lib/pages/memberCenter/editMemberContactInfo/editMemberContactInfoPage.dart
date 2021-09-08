import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/editMemberContactInfoWidget.dart';
import 'package:readr_app/services/memberService.dart';

class EditMemberContactInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMemberContactInfoBloc(memberRepos: MemberService()),
      child: EditMemberContactInfoWidget(),
    );
  }
}