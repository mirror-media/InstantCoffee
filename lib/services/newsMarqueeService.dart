import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/recordList.dart';

class NewsMarqueeService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RecordList> fetchRecordList() async {
    final jsonResponse = await _helper.getByUrl(Environment().config.newsMarqueeApi);

    RecordList records = new RecordList.fromJson(jsonResponse["_items"]);
    return records;
  }
}
