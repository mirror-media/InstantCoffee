import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/services/sectionService.dart';

abstract class SearchRepos {
  Future<SectionList> fetchSectionList();
  Future<RecordList> searchByKeywordAndSectionId(String keyword, {String sectionName = '', int page = 1, int maxResults = 20});
  Future<RecordList> searchNextPageByKeywordAndSectionId(String keyword, {String sectionName = ''});
}

class SearchServices implements SearchRepos{
  ApiBaseHelper _helper = ApiBaseHelper();

  int page = 1;
  int maxResults = 20;

  @override
  Future<SectionList> fetchSectionList() async{
    Section initialTargetSection = Section(
      key: '',
      name: '',
      title: '全部類別',
      description: '',
      order: 0,
      type: 'fixed',
    );
    
    SectionService sectionService = SectionService();
    SectionList sectionList = await sectionService.fetchSectionList(needMenu: false);
    sectionList.insert(
      0, 
      initialTargetSection,
    );

    return sectionList;
  }

  @override
  Future<RecordList> searchByKeywordAndSectionId(String keyword, {String sectionName = '', int page = 1, int maxResults = 20}) async {
    String searchApi = '${env.baseConfig.searchApi}?max_results=$maxResults&page=$page&keywords=$keyword';
    if(sectionName != '' && sectionName != '全部類別') {
      searchApi = '${env.baseConfig.searchApi}?max_results=$maxResults&page=$page&keywords=$keyword&section=$sectionName';
    }

    final jsonResponse = await _helper.getByUrl(searchApi);

    RecordList recordList = RecordList.fromJson(jsonResponse["hits"]["hits"]);
    recordList.allRecordCount = jsonResponse["hits"]["total"]['value'];
    return recordList;
  }

  @override
  Future<RecordList> searchNextPageByKeywordAndSectionId(String keyword, {String sectionName = ''}) async{
    page = page + 1;
    return await searchByKeywordAndSectionId(keyword, sectionName: sectionName, page: page);
  }
}
