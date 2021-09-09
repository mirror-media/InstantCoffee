import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/passwordUpdate/PasswordUpdateWidget.dart';

class PasswordUpdatePage extends StatelessWidget {
  final PasswordUpdateBloc passwordUpdateBloc;
  PasswordUpdatePage({
    @required this.passwordUpdateBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => passwordUpdateBloc,
        child: PasswordUpdateWidget(),
      ),
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