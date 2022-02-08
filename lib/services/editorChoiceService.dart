import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/record.dart';

abstract class EditorChoiceRepos {
  Future<List<Record>> fetchRecordList();
}

class EditorChoiceService implements EditorChoiceRepos {
  ApiBaseHelper helper = ApiBaseHelper();

  Future<List<Record>> fetchRecordList() async {
    final jsonResponse = await helper.getByCacheAndAutoCache(Environment().config.editorChoiceApi, maxAge: editorChoiceCacheDuration);

    List<Record> records =  Record.recordListFromJson(jsonResponse["choices"]);
    return records;
  }
}
