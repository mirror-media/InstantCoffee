import 'dart:io';

import 'package:readr_app/blocs/search/states.dart';
import 'package:readr_app/helpers/appException.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/services/searchService.dart';

abstract class SearchEvents{
  Section targetSection = Section();
  SectionList sectionList = SectionList();
  RecordList searchList = RecordList();
  Stream<SearchState> run(SearchRepos searchRepos);
}

class FetchSectionList extends SearchEvents {
  FetchSectionList();

  @override
  String toString() => 'FetchSectionList';

  @override
  Stream<SearchState> run(SearchRepos searchRepos) async*{
    print(this.toString());
    try{
      yield SearchPageLoading();
      sectionList = await searchRepos.fetchSectionList();
      targetSection = sectionList[0];
      yield SearchPageLoaded(
        targetSection: targetSection,
        sectionList: sectionList
      );
    } on SocketException {
      yield SearchPageError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield SearchPageError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield SearchPageError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } on FetchDataException {
      yield SearchPageError(
        error: NoInternetException('Error During Communication'),
      );
    } catch (e) {
      yield SearchPageError(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class ChangeTargetSection extends SearchEvents {
  final Section section;
  ChangeTargetSection(
    this.section
  );

  @override
  String toString() => 'ChangeTargetSection: targetSection: ${section.name}';

  @override
  Stream<SearchState> run(SearchRepos searchRepos) async*{
    print(this.toString());
    targetSection = section;
    yield SearchPageLoaded(
      targetSection: targetSection,
      sectionList: sectionList
    );
  }
}

class SearchByKeywordAndSectionId extends SearchEvents {
  final String keyword;
  final String sectionName;
  SearchByKeywordAndSectionId(
    this.keyword,
    {
      this.sectionName = '',
    }
  );

  @override
  String toString() => 'SearchByKeywordAndSectionId { keyword: $keyword, sectionName: $sectionName }';

  @override
  Stream<SearchState> run(SearchRepos searchRepos) async*{
    print(this.toString());
    try{
      yield SearchLoading(
        targetSection: targetSection,
        sectionList: sectionList
      );
      searchList = await searchRepos.searchByKeywordAndSectionId(keyword, sectionName: sectionName);
      yield SearchLoaded(
        targetSection: targetSection,
        sectionList: sectionList,
        searchList: searchList
      );
    } on SocketException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: InvalidFormatException('Invalid Response format'),
      );
    } on FetchDataException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: NoInternetException('Error During Communication'),
      );
    } catch (e) {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: UnknownException(e.toString()),
      );
    }
  }
}

class SearchNextPageByKeywordAndSectionId extends SearchEvents {
  final String keyword;
  final String sectionName;
  SearchNextPageByKeywordAndSectionId(
    this.keyword,
    {
      this.sectionName = '',
    }
  );

  @override
  String toString() => 'SearchNextPageByKeywordAndSectionId { keyword: $keyword, sectionName: $sectionName }';

  @override
  Stream<SearchState> run(SearchRepos searchRepos) async*{
    print(this.toString());
    try{
      yield SearchLoadingMore(
        targetSection: targetSection,
        sectionList: sectionList,
        searchList: searchList
      );
      RecordList newSearchList = await searchRepos.searchNextPageByKeywordAndSectionId(keyword, sectionName: sectionName);
      searchList.addAll(newSearchList);
      yield SearchLoaded(
        targetSection: targetSection,
        sectionList: sectionList,
        searchList: searchList
      );
    } on SocketException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: InvalidFormatException('Invalid Response format'),
      );
    } on FetchDataException {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: NoInternetException('Error During Communication'),
      );
    } catch (e) {
      yield SearchError(
        targetSection: targetSection,
        sectionList: sectionList,
        error: UnknownException(e.toString()),
      );
    }
  }
}