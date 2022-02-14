import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/record.dart';

abstract class NewsMarqueeRepos {
  Future<List<Record>> fetchRecordList();
}

class NewsMarqueeService implements NewsMarqueeRepos{
  ApiBaseHelper helper = ApiBaseHelper();

  Future<List<Record>> fetchRecordList() async {
    final jsonResponse = await helper.getByCacheAndAutoCache(
      Environment().config.newsMarqueeApi,
      maxAge: newsMarqueeCacheDuration
    );

    List<Record> records = Record.recordListFromJson(jsonResponse["_items"]);
    return records;
  }
}
