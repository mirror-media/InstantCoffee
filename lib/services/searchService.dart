import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/recordList.dart';

class SearchService {
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;

  Future<RecordList> search(String keyword, {String sectionId = '', int maxResults = 20, int page = 1}) async {
    final jsonResponse = await _helper.getByUrl(
      env.baseConfig.searchApi + '?where={"section":"$sectionId"}&max_results=$maxResults&page=$page&keyword=$keyword'
    );

    RecordList recordList = RecordList.fromJson(jsonResponse["hits"]["hits"]);
    return recordList;
  }

  int initialPage() {
    return this.page = 1;
  }

  int nextPage() {
    return ++ this.page;
  }
}
