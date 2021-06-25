import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/search/bloc.dart';
import 'package:readr_app/blocs/search/events.dart';
import 'package:readr_app/blocs/search/states.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionList.dart';

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

  _searchByKeywordAndSectionId(String keyword, String sectionName) async {
    context.read<SearchBloc>().add(SearchByKeywordAndSectionId(keyword, sectionName: sectionName));
  }

  _searchNextPageByKeywordAndSectionId(String keyword, String sectionName) async {
    context.read<SearchBloc>().add(SearchNextPageByKeywordAndSectionId(keyword, sectionName: sectionName));
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
        if (state is SearchPageError) {
          final error = state.error;
          print('SearchPageError: ${error.message}');
          
          return Container();
        }
        
        if(state is SearchPageLoaded) {
          Section targetSection = state.targetSection;
          SectionList sectionList = state.sectionList;

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

        // SearchPageInitState or SearchPageLoading
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
            _searchByKeywordAndSectionId(
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
    SectionList sectionList,
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
          List<Widget> widgetList = List<Widget>();
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
        _searchByKeywordAndSectionId(
          _textController.text,
          targetSection.title,
        );
      },
    );
  }

  Widget _buildSearchList(SearchState state) {
    if(state is SearchLoaded) {
      Section targetSection = state.targetSection;
      RecordList searchList = state.searchList;
      bool isNeedToLoadMore = searchList.length < searchList.allRecordCount;
      return ListView.separated(
        //controller: _listviewController,
        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16.0),
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          if(isNeedToLoadMore && index == searchList.length - 5) {
            _searchNextPageByKeywordAndSectionId(
              _textController.text,
              targetSection.title,
            );
          }

          return _buildListItem(searchList[index]);
        },
      );
    } 

    if(state is SearchLoadingMore) {
      RecordList searchList = state.searchList;
      return ListView.separated(
        //controller: _listviewController,
        separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16.0),
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          if(index == searchList.length -1) {
            return Column(
              children: [
                _buildListItem(searchList[index]),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child:  Center(child: CupertinoActivityIndicator()),
                ),
              ]
            );
          }

          return _buildListItem(searchList[index]);
        },
      );
    }

    if(state is SearchLoading) {
      return _loadingWidget();
    }

    // SearchError or nothing
    return Container();
  }

  Widget _buildListItem(Record record) {
    var width = MediaQuery.of(context).size.width;
    double imageSize = 25 * (width - 32) / 100;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    record.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                CachedNetworkImage(
                  height: imageSize,
                  width: imageSize,
                  imageUrl: record.photoUrl,
                  placeholder: (context, url) => Container(
                    height: imageSize,
                    width: imageSize,
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: imageSize,
                    width: imageSize,
                    color: Colors.grey,
                    child: Icon(Icons.error),
                  ),
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(height: 8,),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: () => RouteGenerator.navigateToStory(context, record.slug),
    );
  }

  Widget _loadingWidget() =>
      Center(
        child: CircularProgressIndicator(),
      );
}