import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
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
            emit(MagazineLoaded(magazineList: magazineList));
          }

          if (event is FetchNextMagazineListPageByType) {
            emit(MagazineLoadingMore(magazineList: magazineList));
            MagazineList newMagazineList =
                await magazineRepos.fetchNextMagazineListPageByType(
              event.type,
            );
            magazineList.addAll(newMagazineList);
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
}
