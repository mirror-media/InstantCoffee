import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/models/record.dart';

abstract class PersonalSubscriptionRepos {
  int initialPage();
  int nextPage();
  int previousPage();

  Future<List<Record>> fetchRecordList(String categoryListJson, {int page = 1});
  Future<List<Record>> fetchNextRecordList(String categoryListJson);
}

class PersonalSubscriptionService implements PersonalSubscriptionRepos {
  final ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  @override
  int initialPage() {
    return page = 1;
  }

  @override
  int nextPage() {
    return page = page + 1;
  }

  @override
  int previousPage() {
    if (page == 1) {
      return 1;
    }

    return page = page - 1;
  }

  @override
  Future<List<Record>> fetchRecordList(String categoryListJson,
      {int page = 1}) async {
    String url =
        '${Environment().config.apiBase}meta?where={"categories":{"\$in":$categoryListJson},"device":{"\$in":["all","app"]}}&page=$page&sort=-publishedDate&utm_source=app&utm_medium=news&max_results=20';

    final jsonResponse = await _helper.getByUrl(url);
    List<Record> records = Record.recordListFromJson(jsonResponse['_items']);
    return records;
  }

  @override
  Future<List<Record>> fetchNextRecordList(String categoryListJson) async {
    nextPage();
    return await fetchRecordList(categoryListJson, page: page);
  }
}
