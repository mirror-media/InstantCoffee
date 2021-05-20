import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/magazine/specialMagazineWidget.dart';
import 'package:readr_app/pages/magazine/weeklyMagazineWidget.dart';
import 'package:readr_app/pages/magazine/onlineMagazineWidget.dart';
import 'package:readr_app/services/magazineService.dart';

class MagazinePage extends StatefulWidget {
  @override
  _MagazinePageState createState() => _MagazinePageState();
}

class _MagazinePageState extends State<MagazinePage> {
  ScrollController _listviewController = ScrollController();
  
  @override
  void dispose() {
    _listviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: ListView(
        controller: _listviewController,
        children: [
          BlocProvider(
            create: (context) => MagazineBloc(magazineRepos: MagazineServices()),
            child: WeeklyMagazineWidget(),
          ),
          OnlineMagazineWidget(),
          BlocProvider(
            create: (context) => MagazineBloc(magazineRepos: MagazineServices()),
            child: SpecialMagazineWidget(
              listviewController: _listviewController,
            ),
          ),
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