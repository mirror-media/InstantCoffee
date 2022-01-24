import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordListAndAllCount.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/services/sectionService.dart';

abstract class SearchRepos {
  Future<List<Section>> fetchSectionList();
  Future<RecordListAndAllCount> searchByKeywordAndSectionName(String keyword, {String sectionName = '', int page = 1, int maxResults = 20});
  Future<RecordListAndAllCount> searchNextPageByKeywordAndSectionName(String keyword, {String sectionName = ''});
  void reducePage(int count);
}

class SearchServices implements SearchRepos{
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;
  int maxResults = 20;

  @override
  Future<List<Section>> fetchSectionList() async{
    Section initialTargetSection = Section(
      key: '',
      name: '',
      title: '全部類別',
      description: '',
      order: 0,
      focus: false,
      type: 'fixed',
    );
    
    SectionService sectionService = SectionService();
    List<Section> sectionList = await sectionService.fetchSectionList(needMenu: false);
    sectionList.insert(
      0, 
      initialTargetSection,
    );

    return sectionList;
  }

  @override
  Future<RecordListAndAllCount> searchByKeywordAndSectionName(String keyword, {String sectionName = '', int page = 1, int maxResults = 20}) async {
    String searchApi = '${Environment().config.searchApi}?max_results=$maxResults&page=$page&keywords=$keyword';
    if(sectionName != '' && sectionName != '全部類別') {
      searchApi = '${Environment().config.searchApi}?max_results=$maxResults&page=$page&keywords=$keyword&section=$sectionName';
    }

    final jsonResponse = await _helper.getByUrl(searchApi);

    RecordListAndAllCount recordListAndAllCount = RecordListAndAllCount(
      recordList: Record.recordListFromJson(jsonResponse["hits"]["hits"]),
      allCount: jsonResponse["hits"]["total"]['value'],
    );
    return recordListAndAllCount;
  }

  @override
  Future<RecordListAndAllCount> searchNextPageByKeywordAndSectionName(String keyword, {String sectionName = ''}) async{
    page = page + 1;
    return await searchByKeywordAndSectionName(keyword, sectionName: sectionName, page: page);
  }

  @override
  void reducePage(int count) {
    page = page - count;
  }
}
