import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/magazineList.dart';

abstract class MagazineRepos {
  /// type: special or weekly
  Future<MagazineList> fetchMagazineListByType(String type, {int page = 1, int maxResults = 8});
}

class MagazineServices implements MagazineRepos{
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MagazineList> fetchMagazineListByType(String type, {int page = 1, int maxResults = 8}) async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(
      env.baseConfig.magazinesApi + '?max_results=$maxResults&sort=-publishedDate&page&where={"type":{"\$in":["$type"]}}', 
      maxAge: magazineCacheDuration
    );
    MagazineList magazineList = MagazineList.fromJson(jsonResponse['_items']);
    return magazineList;
  }
}
