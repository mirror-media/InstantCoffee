import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/deleteMember/cubit.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/deletMemberWidget.dart';

class DeleteMemberPage extends StatelessWidget {
  final String israfelId;
  DeleteMemberPage({
    @required this.israfelId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DeleteMemberCubit(),
      child: DeleteMemberWidget(israfelId: israfelId),
    );
  }
}