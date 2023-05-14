import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/edit_member_profile_widget.dart';
import 'package:readr_app/services/member_service.dart';

class EditMemberProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditMemberProfileBloc(memberRepos: MemberService()),
      child: EditMemberProfileWidget(),
    );
  }
}
