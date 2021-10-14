import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/magazineList.dart';

abstract class MagazineRepos {
  /// type: special or weekly
  Future<MagazineList> fetchMagazineListByType(String type, {int page = 1, int maxResults = 8});
  Future<MagazineList> fetchNextMagazineListPageByType(String type, {int maxResults = 8});
}

class MagazineServices implements MagazineRepos{
  ApiBaseHelper _helper = ApiBaseHelper();
  int _page = 1;

  Future<MagazineList> fetchMagazineListByType(String type, {int page = 1, int maxResults = 8}) async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(
      Environment().config.magazinesApi + '?max_results=$maxResults&sort=-publishedDate&page=$page&where={"type":{"\$in":["$type"]}}', 
      maxAge: magazineCacheDuration
    );
    MagazineList magazineList = MagazineList.fromJson(jsonResponse['_items']);
    magazineList.total = jsonResponse['_meta']['total'];
    return magazineList;
  }

  Future<MagazineList> fetchNextMagazineListPageByType(String type, {int maxResults = 8}) async {
    _page = _page + 1;
    MagazineList magazineList = await fetchMagazineListByType(type, page: _page, maxResults: maxResults);
    return magazineList;
  }
}
