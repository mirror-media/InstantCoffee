import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/searchPageBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionList.dart';

class SearchWidget extends StatefulWidget {
  final SearchPageBloc searchPageBloc;
  final SectionList sectionList;
  SearchWidget({
    @required this.searchPageBloc,
    @required this.sectionList,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String keyword;

  @override
  void initState() {
    keyword = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = (MediaQuery.of(context).size.width-68)/10;
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _keywordTextField(5*width, widget.searchPageBloc),
              _selectSectionButton(4*width, height, widget.searchPageBloc, widget.sectionList),
              _searchButton(widget.searchPageBloc),
            ],
          ),
        ),
        _buildSearchList(context, widget.searchPageBloc),
      ],
    );
  }

  Widget _keywordTextField(double width, SearchPageBloc searchPageBloc) {
    return Container(
      width: width,
      child: TextField(
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
        onChanged: (value) {
          keyword = value;
        },
        onSubmitted: (value) {
          searchPageBloc.search(keyword);
        }
      ),
    );
  }

  Widget _selectSectionButton(double width, double height, SearchPageBloc searchPageBloc, SectionList sectionList) {
    return StreamBuilder<Section>(
      initialData: searchPageBloc.initialTargetSection,
      stream: searchPageBloc.targetSectionStream,
      builder: (context, snapshot) {
        Section section = snapshot.data;
        return InkWell(
          borderRadius: BorderRadius.circular((3.0)),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular((3.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 11.0, 16.0, 11.0),
              child: Text(
                section.title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          onTap: () {
            List<Widget> widgetList = List<Widget>();
            sectionList.forEach(
              (category) {
                widgetList.add(
                  Container(
                    color: Colors.black87,
                    child: CupertinoActionSheetAction(
                      child: Text(category.title),
                      onPressed: () {
                        searchPageBloc.targetSectionSinkToAdd(category);
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
                builder: (BuildContext context) => Container(height: height*2/3, child: act));
          },
        );
      }
    );
  }

  Widget _searchButton(SearchPageBloc searchPageBloc) {
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
        print('search');
        searchPageBloc.search(keyword);
      },
    );
  }
  
  Widget _buildSearchList(BuildContext context, SearchPageBloc searchPageBloc) {
    return StreamBuilder<ApiResponse<RecordList>>(
      stream: searchPageBloc.searchStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Expanded(child: Center(child: CircularProgressIndicator()));
              break;

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              RecordList recordList = searchPageBloc.searchList;

              return Expanded(
                child: ListView.builder(
                  itemCount: recordList.length,
                  itemBuilder: (BuildContext context, int index) {
                    searchPageBloc.loadingMore(keyword, index);
                      
                    if(index == recordList.length - 1 && 
                      snapshot.data.status == Status.LOADINGMORE) {
                      return Column(
                        children: [
                          _buildListItem(context, recordList[index]),
                          _loadMoreWidget(),
                        ],
                      );
                    }
                    return _buildListItem(context, recordList[index]);
                  },
                ),
              );
              break;

            case Status.ERROR:
              return Container();
              break;
          }
        }
        return Container();
      },
    );
  }

  Widget _buildListItem(BuildContext context, Record record) {
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

  Widget _loadMoreWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: CupertinoActivityIndicator()
      ),
    );
  }
}