import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/record.dart';

class EditorChoiceService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Record>> fetchRecordList() async {
    final jsonResponse = await _helper.getByCacheAndAutoCache(Environment().config.editorChoiceApi, maxAge: editorChoiceCacheDuration);

    List<Record> records =  Record.recordListFromJson(jsonResponse["choices"]);
    return records;
  }
}
