import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/search/events.dart';
import 'package:readr_app/blocs/search/states.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/services/searchService.dart';

class SearchBloc extends Bloc<SearchEvents, SearchState> {
  Section targetSection = Section();
  SectionList sectionList = SectionList();
  RecordList searchList = RecordList();
  final SearchRepos searchRepos;
  
  SearchBloc({this.searchRepos}) : super(SearchPageInitState());

  @override
  Stream<SearchState> mapEventToState(SearchEvents event) async* {
    event.targetSection = targetSection;
    event.sectionList = sectionList;
    event.searchList = searchList;
    yield* event.run(searchRepos);
    targetSection = event.targetSection;
    sectionList = event.sectionList;
    searchList = event.searchList;
  }
}
