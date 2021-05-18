import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/magazine/events.dart';
import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/services/magazineService.dart';


class MagazineBloc extends Bloc<MagazineEvents, MagazineState> {
  final MagazineRepos magazineRepos;

  MagazineBloc({this.magazineRepos}) : super(MagazineInitState());

  @override
  Stream<MagazineState> mapEventToState(MagazineEvents event) async* {
    yield* event.run(magazineRepos);
  }
}
