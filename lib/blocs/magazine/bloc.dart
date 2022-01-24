import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/models/magazineList.dart';
import 'package:readr_app/services/magazineService.dart';


class MagazineBloc extends Bloc<MagazineEvents, MagazineState> {
  final MagazineRepos magazineRepos;
  MagazineList magazineList = MagazineList();

  MagazineBloc({required this.magazineRepos}) : super(MagazineInitState());

  @override
  Stream<MagazineState> mapEventToState(MagazineEvents event) async* {
    event.magazineList = magazineList;
    yield* event.run(magazineRepos);
    magazineList = event.magazineList;
  }
}
