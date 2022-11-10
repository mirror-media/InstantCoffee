import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:readr_app/models/election/municipality.dart';
import 'package:readr_app/services/electionService.dart';

part 'election_state.dart';

class ElectionCubit extends Cubit<ElectionState> {
  final ElectionRepos repos;
  ElectionCubit(this.repos) : super(ElectionInitial());

  void fetchMunicipalityData() async {
    emit(UpdatingElectionData());
    try {
      var result = await repos.fetchMunicipalityData();
      emit(ElectionDataLoaded(
        lastUpdateTime: result['lastUpdateTime'],
        municipalityList: result['municipalityList'],
      ));
    } catch (e) {
      print('Fetch election data failed: $e');
      emit(ElectionDataError());
    }
  }

  void hideElectionBlock() {
    emit(HideElectionBlock());
  }
}
