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
  bool _requestedLoadMore = false;
  int _lastLength = 0;
  MagazineList? _lastSuccessMagazineList;

  @override
  bool get wantKeepAlive => true;

  void _onScroll() {
    if (!mounted) return;
    if (!widget.listviewController.hasClients) return;

    final position = widget.listviewController.position;
    final bool isNearBottom = position.extentAfter < 200;
    if (!_isLoadingMoreDone &&
        !_isLoading &&
        !_requestedLoadMore &&
        isNearBottom) {
      _isLoading = true;
      _requestedLoadMore = true;
      _fetchNextMagazineListPageBySpecialType();
    }
  }

  @override
  void initState() {
    _fetchMagazineListBySpecialType();
    widget.listviewController.addListener(_onScroll);
    super.initState();
  }

  _fetchMagazineListBySpecialType() {
    _isLoadingMoreDone = false;
    _isLoading = true;
    _requestedLoadMore = false;
    _lastLength = 0;
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
        _isLoading = false;
        _requestedLoadMore = false;
        if (_lastSuccessMagazineList != null) {
          return SpecialMagazineListWidget(
            magazineList: _lastSuccessMagazineList!,
            magazineState: state,
            isLoadingMoreDone: _isLoadingMoreDone,
          );
        }
        return Container();
      }

      if (state is MagazineLoaded) {
        MagazineList magazineList = state.magazineList;
        _lastSuccessMagazineList = magazineList;
        if (_requestedLoadMore) {
          if (magazineList.length == _lastLength) {
            _isLoadingMoreDone = true;
          }
          _requestedLoadMore = false;
        }
        _lastLength = magazineList.length;
        _isLoading = false;

        return SpecialMagazineListWidget(
          magazineList: magazineList,
          magazineState: state,
          isLoadingMoreDone: _isLoadingMoreDone,
        );
      }

      if (state is MagazineLoadingMore) {
        _lastSuccessMagazineList = state.magazineList;
        return SpecialMagazineListWidget(
          magazineList: state.magazineList,
          magazineState: state,
        );
      }

      // state is Init, Loading
      // Avoid duplicate loading indicators with weekly list.
      return const SizedBox.shrink();
    });
  }
}
