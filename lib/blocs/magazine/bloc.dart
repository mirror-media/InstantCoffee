import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/helpers/network_time_helper.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/magazine_list.dart';
import 'package:readr_app/services/magazine_service.dart';
import 'package:readr_app/widgets/logger.dart';

class MagazineBloc extends Bloc<MagazineEvents, MagazineState> with Logger {
  final MagazineRepos magazineRepos;
  MagazineList magazineList = MagazineList();

  MagazineBloc({required this.magazineRepos}) : super(MagazineInitState()) {
    on<MagazineEvents>(
      (event, emit) async {
        debugLog(event.toString());

        try {
          if (event is FetchMagazineListByType) {
            magazineList = MagazineList();
            emit(MagazineLoading());
            magazineList = await magazineRepos.fetchMagazineListByType(
              event.type,
            );
            final MagazineList filtered =
                await _filterVisibleMagazines(magazineList);
            magazineList = filtered;
            emit(MagazineLoaded(magazineList: filtered));
          }

          if (event is FetchNextMagazineListPageByType) {
            emit(MagazineLoadingMore(magazineList: magazineList));
            MagazineList newMagazineList =
                await magazineRepos.fetchNextMagazineListPageByType(
              event.type,
            );
            final MagazineList filtered =
                await _filterVisibleMagazines(newMagazineList);
            magazineList.addAll(filtered);
            emit(MagazineLoaded(magazineList: magazineList));
          }
        } catch (e) {
          emit(MagazineError(
            error: determineException(e),
          ));
        }
      },
    );
  }

  Future<MagazineList> _filterVisibleMagazines(MagazineList list) async {
    final DateTime? networkUtcNow =
        await NetworkTimeHelper().fetchNetworkUtcNow();
    final DateTime nowUtc = networkUtcNow ?? DateTime.now().toUtc();
    MagazineList filtered = MagazineList();
    for (final Magazine magazine in list) {
      if (_shouldShowMagazine(magazine, nowUtc)) {
        filtered.add(magazine);
      }
    }
    return filtered;
  }

  bool _shouldShowMagazine(Magazine magazine, DateTime nowUtc) {
    final String state = magazine.state?.toLowerCase() ?? '';
    if (state == 'archived' || state == 'draft' || state == 'invisible') {
      return false;
    }
    if (state != 'published' && state != 'scheduled') {
      return false;
    }
    final String? publishedDate = magazine.publishedDate;
    if (publishedDate == null) {
      return false;
    }
    final DateTime? published = DateTime.tryParse(publishedDate);
    if (published == null) {
      return false;
    }
    final DateTime publishedUtc =
        published.isUtc ? published : published.toUtc();
    return !nowUtc.isBefore(publishedUtc);
  }
}
