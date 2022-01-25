import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/search/bloc.dart';
import 'package:readr_app/blocs/search/events.dart';
import 'package:readr_app/blocs/search/states.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/search/searchListItem.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _fetchSectionList();
    super.initState();
  }

  _fetchSectionList() async {
    context.read<SearchBloc>().add(FetchSectionList());
  }

  _changeTargetSection(Section targetSection) async {
    context.read<SearchBloc>().add(ChangeTargetSection(targetSection));
  }

  _searchByKeywordAndSectionName(String keyword, String sectionName) async {
    context.read<SearchBloc>().add(SearchByKeywordAndSectionName(keyword, sectionName: sectionName));
  }

  _searchNextPageByKeywordAndSectionName(String keyword, String sectionName) async {
    context.read<SearchBloc>().add(SearchNextPageByKeywordAndSectionName(keyword, sectionName: sectionName));
  }

  bool _isSearchStatus(SearchStatus status) {
    return status == SearchStatus.searchLoading ||
        status == SearchStatus.searchLoaded ||
        status == SearchStatus.searchLoadingError ||
        status == SearchStatus.searchLoadingMore ||
        status == SearchStatus.searchLoadingMoreFail;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width-68)/10;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        SearchStatus status = state.status;
        if (status == SearchStatus.sectionListLoadingError) {
          final error = state.errorMessages;
          print('SectionListLoadingError: $error');
          
          return Container();
        }
        
        if(status == SearchStatus.sectionListLoaded ||
          _isSearchStatus(status)
        ) {
          Section targetSection = state.targetSection!;
          List<Section> sectionList = state.sectionList!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _keywordTextField(5*width, targetSection),
                    _selectSectionButton(4*width, height, sectionList, targetSection),
                    _searchButton(targetSection),
                  ],
                ),
              ),

              Expanded(child: _buildSearchList(state)),
            ],
          );
        }

        // initial or sectionListLoading
        return _loadingWidget();
      }
    );
  }

  Widget _keywordTextField(double width, Section targetSection) {
    return Container(
      width: width,
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.grey,),
        child: TextField(
          controller: _textController,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            hintText: "請輸入關鍵字",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          onSubmitted: (value) {
            _searchByKeywordAndSectionName(
              _textController.text,
              targetSection.title,
            );
          }
        ),
      ),
    );
  }

  Widget _selectSectionButton(    
    double width, 
    double height, 
    List<Section> sectionList,
    Section targetSection,
  ) {
    return Container(
      width: width,
      child: OutlinedButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
              child: Text(
                targetSection.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0))
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(
              color: Colors.grey,
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        onPressed: () {
          List<Widget> widgetList = [];
          sectionList.forEach(
            (category) {
              widgetList.add(
                Container(
                  color: Colors.black87,
                  child: CupertinoActionSheetAction(
                    child: Text(category.title),
                    onPressed: () {
                      _changeTargetSection(category);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            }
          );
          final act = CupertinoActionSheet(
            actions: widgetList,
            cancelButton: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: CupertinoActionSheetAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          );
          showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(height: height*2/3, child: act),
              ));
        },
      ),
    );
  }

  Widget _searchButton(Section targetSection) {
    return InkWell(
      child: Container(
        color: Colors.grey[400],
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.search,
            color: Colors.white,
            size: 36,
          ),
        ),
      ), 
      onTap: () {
        _searchByKeywordAndSectionName(
          _textController.text,
          targetSection.title,
        );
      },
    );
  }

  Widget _buildSearchList(SearchState state) {
    SearchStatus status = state.status;
    if(status == SearchStatus.searchLoaded) {
      Section targetSection = state.targetSection!;
      List<Record> searchList = state.searchStoryList!;
      bool isNeedToLoadMore = searchList.length < state.searchListTotal!;

      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16.0),
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          if(isNeedToLoadMore && index == searchList.length - 5) {
            _searchNextPageByKeywordAndSectionName(
              _textController.text,
              targetSection.title,
            );
          }

          return SearchListItem(record: searchList[index]);
        },
      );
    } 

    if(status == SearchStatus.searchLoadingMore) {
      List<Record> searchList = state.searchStoryList!;
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16.0),
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          if(index == searchList.length -1) {
            return Column(
              children: [
                SearchListItem(record: searchList[index]),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child:  Center(child: CupertinoActivityIndicator()),
                ),
              ]
            );
          }

          return SearchListItem(record: searchList[index]);
        },
      );
    }

    if(status == SearchStatus.searchLoading) {
      return _loadingWidget();
    }

    // searchLoadingError or searchLoadingMoreFail
    return Container();
  }

  Widget _loadingWidget() =>
      Center(
        child: CircularProgressIndicator(),
      );
}