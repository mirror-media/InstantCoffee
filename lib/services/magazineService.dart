import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/magazineList.dart';

class MagazineService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<MagazineList> fetchMagazineList() async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(env.baseConfig.magazinesApi, maxAge: magazineCacheDuration);
    MagazineList magazineList = MagazineList.fromJson(jsonResponse['_items']);
    return magazineList;
  }
}
