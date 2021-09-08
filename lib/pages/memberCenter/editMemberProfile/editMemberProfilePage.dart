import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/editMemberProfileWidget.dart';

class EditMemberProfilePage extends StatelessWidget {
  final EditMemberProfileBloc editMemberProfileBloc;
  EditMemberProfilePage({
    @required this.editMemberProfileBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => editMemberProfileBloc,
      child: EditMemberProfileWidget(),
    );
  }
}