import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/helpers/errorHelper.dart';
import 'package:readr_app/models/magazineList.dart';
import 'package:readr_app/services/magazineService.dart';

class MagazineBloc extends Bloc<MagazineEvents, MagazineState> {
  final MagazineRepos magazineRepos;
  MagazineList magazineList = MagazineList();

  MagazineBloc({required this.magazineRepos}) : super(MagazineInitState()) {
    on<MagazineEvents>(
      (event, emit) async {
        print(event.toString());

        try {
          if (event is FetchMagazineListByType) {
            magazineList = MagazineList();
            emit(MagazineLoading());
            magazineList = await magazineRepos.fetchMagazineListByType(
              event.type,
              page: event.page,
              maxResults: event.maxResult,
            );
            emit(MagazineLoaded(magazineList: magazineList));
          }

          if (event is FetchNextMagazineListPageByType) {
            emit(MagazineLoadingMore(magazineList: magazineList));
            MagazineList newMagazineList =
                await magazineRepos.fetchNextMagazineListPageByType(
              event.type,
              maxResults: event.maxResult,
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
