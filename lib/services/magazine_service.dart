import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/models/magazine_list.dart';

abstract class MagazineRepos {
  /// type: special or weekly
  Future<MagazineList> fetchMagazineListByType(String type,
      {int page = 1, int maxResults = 8});
  Future<MagazineList> fetchNextMagazineListPageByType(String type,
      {int maxResults = 8});
}

class MagazineServices implements MagazineRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();
  int _page = 1;

  @override
  Future<MagazineList> fetchMagazineListByType(String type,
      {int page = 1, int maxResults = 8}) async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(
        '${Environment().config.magazinesApi}?max_results=$maxResults&sort=-publishedDate&page=$page&where={"type":{"\$in":["$type"]}}',
        maxAge: magazineCacheDuration);
    MagazineList magazineList =
        MagazineList.fromJson(jsonResponse['_items'], type);
    magazineList.total = jsonResponse['_meta']['total'];
    return magazineList;
  }

  @override
  Future<MagazineList> fetchNextMagazineListPageByType(String type,
      {int maxResults = 8}) async {
    _page = _page + 1;
    MagazineList magazineList = await fetchMagazineListByType(type,
        page: _page, maxResults: maxResults);
    return magazineList;
  }
}
