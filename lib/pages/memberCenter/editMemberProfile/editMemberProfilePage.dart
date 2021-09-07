import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/editMemberProfileWidget.dart';
import 'package:readr_app/services/memberService.dart';

class EditMemberProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMemberProfileBloc(memberRepos: MemberService()),
      child: EditMemberProfileWidget(),
    );
  }
}