import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/helpers/cache_duration_cache.dart';
import 'package:readr_app/models/record.dart';

abstract class EditorChoiceRepos {
  Future<List<Record>> fetchRecordList();
}

class EditorChoiceService implements EditorChoiceRepos {
  ApiBaseHelper helper = ApiBaseHelper();

  @override
  Future<List<Record>> fetchRecordList() async {
    final jsonResponse = await helper.getByCacheAndAutoCache(
        Environment().config.editorChoiceApi,
        maxAge: editorChoiceCacheDuration);

    List<Record> records = Record.recordListFromJson(jsonResponse["choices"]);
    return records;
  }
}
