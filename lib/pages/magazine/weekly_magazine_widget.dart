import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/models/magazine_list.dart';
import 'package:readr_app/pages/magazine/weekly_magazine_list_widget.dart';
import 'package:readr_app/widgets/logger.dart';

class WeeklyMagazineWidget extends StatefulWidget {
  @override
  _WeeklyMagazineWidgetState createState() => _WeeklyMagazineWidgetState();
}

class _WeeklyMagazineWidgetState extends State<WeeklyMagazineWidget>
    with AutomaticKeepAliveClientMixin, Logger {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _fetchMagazineListByWeeklyType();
    super.initState();
  }

  _fetchMagazineListByWeeklyType() {
    context.read<MagazineBloc>().add(FetchMagazineListByType('weekly'));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MagazineBloc, MagazineState>(
        builder: (BuildContext context, MagazineState state) {
      if (state is MagazineError) {
        final error = state.error;
        debugLog('WeeklyMagazineError: ${error.message}');
        return Container();
      }
      if (state is MagazineLoaded) {
        MagazineList magazineList = state.magazineList;

        return WeeklyMagazineListWidget(magazineList: magazineList);
      }

      // state is Init, Loading
      return _loadingWidget();
    });
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
