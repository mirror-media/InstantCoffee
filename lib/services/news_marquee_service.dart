import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/models/record.dart';

abstract class NewsMarqueeRepos {
  Future<List<Record>> fetchRecordList();
}

class NewsMarqueeService implements NewsMarqueeRepos {
  ApiBaseHelper helper = ApiBaseHelper();

  @override
  Future<List<Record>> fetchRecordList() async {
    final jsonResponse = await helper.getByCacheAndAutoCache(
        Environment().config.newsMarqueeApi,
        maxAge: newsMarqueeCacheDuration);

    List<Record> records = Record.recordListFromJson(jsonResponse["_items"]);
    return records;
  }
}
