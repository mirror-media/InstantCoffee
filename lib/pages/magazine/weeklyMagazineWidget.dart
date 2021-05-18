import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/models/magazineList.dart';
import 'package:readr_app/pages/magazine/weeklyMagazineListWidget.dart';

class WeeklyMagazineWidget extends StatefulWidget {
  @override
  _WeeklyMagazineWidgetState createState() => _WeeklyMagazineWidgetState();
}

class _WeeklyMagazineWidgetState extends State<WeeklyMagazineWidget> {
  @override
  void initState() {
    _fetchMagazineListByWeeklyType();
    super.initState();
  }

  _fetchMagazineListByWeeklyType() {
    context.read<MagazineBloc>().add(
      FetchMagazineListByType('weekly')
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MagazineBloc, MagazineState>(
      builder: (BuildContext context, MagazineState state) {
        if (state is MagazineError) {
          final error = state.error;
          print('EmailRegisteredFail: ${error.message}');
          return Container();
        }
        if (state is MagazineLoaded) {
          MagazineList magazineList = state.magazineList;

          return WeeklyMagazineListWidget(magazineList: magazineList);
        }

        // state is Init, Loading
        return _loadingWidget();
      }
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }
}