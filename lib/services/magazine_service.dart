import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/magazine_list.dart';

abstract class MagazineRepos {
  /// type: special or weekly
  Future<MagazineList> fetchMagazineListByType(String type);

  Future<MagazineList> fetchNextMagazineListPageByType(String type);
}

class MagazineServices implements MagazineRepos {
  final ArticlesApiProvider articlesApiProvider = Get.find();
  int _page = 1;

  @override
  Future<MagazineList> fetchMagazineListByType(
    String type,
  ) async {
    _page = 1;
    MagazineList magazineList =
        await articlesApiProvider.getMagazinesList(type);
    return magazineList;
  }

  @override
  Future<MagazineList> fetchNextMagazineListPageByType(String type) async {
    _page = _page + 1;
    MagazineList magazineList =
        await articlesApiProvider.getMagazinesList(type, page: _page);
    return magazineList;
  }
}
