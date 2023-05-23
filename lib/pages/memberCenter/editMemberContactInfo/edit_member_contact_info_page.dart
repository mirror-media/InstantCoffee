import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/edit_member_contact_info_widget.dart';
import 'package:readr_app/services/member_service.dart';

class EditMemberContactInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditMemberContactInfoBloc(memberRepos: MemberService()),
      child: EditMemberContactInfoWidget(),
    );
  }
}
