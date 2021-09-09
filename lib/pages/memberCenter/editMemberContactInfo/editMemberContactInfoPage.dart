import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/editMemberContactInfoWidget.dart';

class EditMemberContactInfoPage extends StatelessWidget {
  final EditMemberContactInfoBloc editMemberContactInfoBloc;
  EditMemberContactInfoPage({
    @required this.editMemberContactInfoBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => editMemberContactInfoBloc,
      child: EditMemberContactInfoWidget(),
    );
  }
}