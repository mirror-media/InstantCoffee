import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/record.dart';

class NewsMarqueeService {
  ApiBaseHelper helper = ApiBaseHelper();

  Future<List<Record>> fetchRecordList() async {
    final jsonResponse = await helper.getByUrl(Environment().config.newsMarqueeApi);

    List<Record> records = Record.recordListFromJson(jsonResponse["_items"]);
    return records;
  }
}
