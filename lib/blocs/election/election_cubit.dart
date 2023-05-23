import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:readr_app/models/election/municipality.dart';
import 'package:readr_app/services/election_service.dart';
import 'package:readr_app/widgets/logger.dart';

part 'election_state.dart';

class ElectionCubit extends Cubit<ElectionState> with Logger {
  final ElectionRepos repos;
  ElectionCubit(this.repos) : super(ElectionInitial());

  void fetchMunicipalityData(String api) async {
    emit(UpdatingElectionData());
    try {
      var result = await repos.fetchMunicipalityData(api);
      emit(ElectionDataLoaded(
        lastUpdateTime: result['lastUpdateTime'],
        municipalityList: result['municipalityList'],
      ));
    } catch (e) {
      debugLog('Fetch election data failed: $e');
      emit(ElectionDataError());
    }
  }

  void hideWidget() {
    emit(HideWidget());
  }
}
