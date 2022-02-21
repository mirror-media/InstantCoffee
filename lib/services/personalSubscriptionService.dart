import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/record.dart';

abstract class PersonalSubscriptionRepos {
  Future<List<Record>> fetchRecordList(String categoryListJson, {int page = 1});
  Future<List<Record>> fetchNextRecordList(String categoryListJson);
}

class PersonalSubscriptionService implements PersonalSubscriptionRepos{
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  Future<List<Record>> fetchRecordList(String categoryListJson, {int page = 1}) async {
    String url = Environment().config.apiBase +
        'meta?where={"categories":{"\$in":$categoryListJson},"device":{"\$in":["all","app"]}}' +
        '&page=$page&sort=-publishedDate&utm_source=app&utm_medium=news&max_results=20';

    final jsonResponse = await _helper.getByUrl(url);
    List<Record> records = Record.recordListFromJson(jsonResponse['_items']);
    return records;
  }

  Future<List<Record>> fetchNextRecordList(String categoryListJson) async {
    nextPage();
    return await fetchRecordList(categoryListJson, page: this.page);
  }

  int initialPage() {
    return this.page = 1;
  }

  int nextPage() {
    return ++ this.page;
  }
}
