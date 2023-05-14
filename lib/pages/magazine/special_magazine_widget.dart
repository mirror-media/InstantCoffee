import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/models/magazine_list.dart';
import 'package:readr_app/pages/magazine/special_magazine_list_widget.dart';
import 'package:readr_app/widgets/logger.dart';

class SpecialMagazineWidget extends StatefulWidget {
  final ScrollController listviewController;
  const SpecialMagazineWidget({
    required this.listviewController,
  });

  @override
  _SpecialMagazineWidgetState createState() => _SpecialMagazineWidgetState();
}

class _SpecialMagazineWidgetState extends State<SpecialMagazineWidget>
    with AutomaticKeepAliveClientMixin, Logger {
  bool _isLoadingMoreDone = false;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _fetchMagazineListBySpecialType();
    widget.listviewController.addListener(() {
      if (!_isLoadingMoreDone &&
          !_isLoading &&
          widget.listviewController.position.pixels ==
              widget.listviewController.position.maxScrollExtent) {
        _isLoading = true;
        _fetchNextMagazineListPageBySpecialType();
      }
    });
    super.initState();
  }

  _fetchMagazineListBySpecialType() {
    context
        .read<MagazineBloc>()
        .add(FetchMagazineListByType('special', maxResult: 6));
  }

  _fetchNextMagazineListPageBySpecialType() {
    context
        .read<MagazineBloc>()
        .add(FetchNextMagazineListPageByType('special', maxResult: 6));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MagazineBloc, MagazineState>(
        builder: (BuildContext context, MagazineState state) {
      if (state is MagazineError) {
        final error = state.error;
        debugLog('SpecialMagazineError: ${error.message}');
        return Container();
      }

      if (state is MagazineLoaded) {
        MagazineList magazineList = state.magazineList;
        if (magazineList.length >= magazineList.total) {
          _isLoadingMoreDone = true;
        }
        _isLoading = false;

        return SpecialMagazineListWidget(
          magazineList: magazineList,
          magazineState: state,
          isLoadingMoreDone: _isLoadingMoreDone,
        );
      }

      if (state is MagazineLoadingMore) {
        return SpecialMagazineListWidget(
          magazineList: state.magazineList,
          magazineState: state,
        );
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
