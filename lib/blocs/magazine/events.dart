import 'dart:io';

import 'package:readr_app/blocs/magazine/states.dart';
import 'package:readr_app/models/magazineList.dart';
import 'package:readr_app/services/magazineService.dart';
import 'package:readr_app/helpers/exceptions.dart';

abstract class MagazineEvents{
  MagazineList magazineList;
  Stream<MagazineState> run(MagazineRepos magazineRepos);
}

class FetchMagazineListByType extends MagazineEvents {
  final String type;
  final int page;
  final int maxResult;
  FetchMagazineListByType(
    this.type, 
    {
      this.page = 1,
      this.maxResult = 8,
    }
  );

  @override
  String toString() => 'FetchMagazineListByType { type: $type }';

  @override
  Stream<MagazineState> run(MagazineRepos magazineRepos) async*{
    print(this.toString());
    try{
      yield MagazineLoading();
      magazineList = await magazineRepos.fetchMagazineListByType(
        type,
        page: page,
        maxResults: maxResult,
      );
      yield MagazineLoaded(magazineList: magazineList);
    } on SocketException {
      yield MagazineError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield MagazineError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield MagazineError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield MagazineError(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class FetchNextMagazineListPageByType extends MagazineEvents {
  final String type;
  final int maxResult;
  FetchNextMagazineListPageByType(
    this.type, 
    {
      this.maxResult = 8,
    }
  );

  @override
  String toString() => 'FetchMagazineListByType { type: $type }';

  @override
  Stream<MagazineState> run(MagazineRepos magazineRepos) async*{
    print(this.toString());
    try{
      yield MagazineLoadingMore(magazineList: magazineList);
      MagazineList newMagazineList = await magazineRepos.fetchNextMagazineListPageByType(
        type,
        maxResults: maxResult,
      );
      magazineList.addAll(newMagazineList);
      yield MagazineLoaded(magazineList: magazineList);
    } on SocketException {
      yield MagazineError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield MagazineError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield MagazineError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield MagazineError(
        error: UnknownException(e.toString()),
      );
    }
  }
}