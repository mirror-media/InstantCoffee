import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/cacheDurationCache.dart';
import 'package:readr_app/models/recordList.dart';

class EditorChoiceService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RecordList> fetchRecordList() async {
    final jsonResponse = await _helper.getByCache(env.baseConfig.editorChoiceApi, maxAge: editorChoiceCacheDuration);

    RecordList records = new RecordList.fromJson(jsonResponse["choices"]);
    return records;
  }
}
