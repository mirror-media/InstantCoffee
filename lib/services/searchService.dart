import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordListAndAllCount.dart';

abstract class SearchRepos {
  Future<RecordListAndAllCount> searchByKeyword(String keyword,
      {int startIndex = 1});
  Future<RecordListAndAllCount> searchNextPageByKeyword(String keyword);
}

class SearchServices implements SearchRepos {
  ApiBaseHelper _helper = ApiBaseHelper();

  int _startIndex = 1;

  @override
  Future<RecordListAndAllCount> searchByKeyword(String keyword,
      {int startIndex = 1}) async {
    String searchApi =
        '${Environment().config.searchApi}&q=$keyword&start=$startIndex';

    final jsonResponse = await _helper.getByCacheAndAutoCache(
      searchApi,
      maxAge: const Duration(hours: 0),
    );

    RecordListAndAllCount recordListAndAllCount = RecordListAndAllCount(
      recordList: jsonResponse["searchInformation"]["totalResults"] != '0'
          ? Record.recordListFromSearchJson(jsonResponse["items"])
          : [],
      allCount: int.parse(jsonResponse["searchInformation"]["totalResults"]),
    );

    if (jsonResponse['queries'].containsKey('nextPage')) {
      _startIndex = jsonResponse['queries']['nextPage'][0]['startIndex'];
    } else {
      _startIndex = 1;
    }

    return recordListAndAllCount;
  }

  @override
  Future<RecordListAndAllCount> searchNextPageByKeyword(String keyword) async {
    return await searchByKeyword(keyword, startIndex: _startIndex);
  }
}
