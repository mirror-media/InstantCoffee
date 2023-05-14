import 'package:readr_app/models/magazine_list.dart';

abstract class MagazineState {}

class MagazineInitState extends MagazineState {}

class MagazineLoading extends MagazineState {}

class MagazineLoadingMore extends MagazineState {
  final MagazineList magazineList;
  MagazineLoadingMore({required this.magazineList});
}

class MagazineLoaded extends MagazineState {
  final MagazineList magazineList;
  MagazineLoaded({required this.magazineList});
}

class MagazineError extends MagazineState {
  final dynamic error;
  MagazineError({this.error});
}
