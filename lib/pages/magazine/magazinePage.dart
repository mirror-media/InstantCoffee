import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/magazine/magazineWidget.dart';
import 'package:readr_app/pages/magazine/onlineMagazineWidget.dart';
import 'package:readr_app/services/magazineService.dart';

class MagazinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body:  ListView(
        children: [
          BlocProvider(
            create: (context) => MagazineBloc(magazineRepos: MagazineServices()),
            child: MagazineWidget(),
          ),
          OnlineMagazineWidget(),
        ],
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
      title: Text('下載電子雜誌'),
      backgroundColor: appColor,
    );
  }
}