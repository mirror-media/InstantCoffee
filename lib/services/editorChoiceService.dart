import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/helpers/apiConstants.dart';
import 'package:readr_app/models/recordList.dart';

class EditorChoiceService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RecordList> fetchRecordList() async {
    final jsonResponse = await _helper.getByUrl(editorChoiceApi);

    RecordList records = new RecordList.fromJson(jsonResponse["choices"]);
    return records;
  }
}
