import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/personalPageBloc.dart';
import 'package:readr_app/helpers/apiConstants.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/categoryList.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/pages/storyPage.dart';
import 'package:readr_app/widgets/unsubscriptionCategoryList.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  PersonalPageBloc _personalPageBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    _personalPageBloc = PersonalPageBloc();
    _scrollController = ScrollController();

    _scrollController.addListener(_loadingMore);
    super.initState();
  }

  _loadingMore() {
    _personalPageBloc.loadingMore(_scrollController);
  }

  _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _personalPageBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<ApiResponse<CategoryList>>(
        stream: _personalPageBloc.categoryStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.LOADINGMORE:
              case Status.COMPLETED:
                CategoryList categoryList = snapshot.data.data;

                return ListView(controller: _scrollController, children: [
                  _buildCategoryList(context, categoryList, _personalPageBloc),
                  Divider(
                    height: 32,
                    thickness: 1.5,
                    color: Colors.black,
                  ),
                  StreamBuilder<ApiResponse<RecordList>>(
                    stream: _personalPageBloc.personalSubscriptionStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Center(child: CircularProgressIndicator());
                            break;

                          case Status.LOADINGMORE:
                          case Status.COMPLETED:
                            RecordList recordList = snapshot.data.data == null
                                ? _personalPageBloc.recordList
                                : snapshot.data.data;

                            return _buildSubscribtoinList(
                                context, recordList, snapshot.data.status);
                            break;

                          case Status.ERROR:
                            return Container();
                            break;
                        }
                      }
                      return Container();
                    },
                  ),
                ]);
                break;

              case Status.ERROR:
                return Container();
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          _scrollToTop();
        },
        child: Text(
          personalPageTitle,
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
      backgroundColor: appColor,
    );
  }

  Widget _buildCategoryList(
      BuildContext context, CategoryList categoryList, PersonalPageBloc personalPageBloc) {
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 48),
            Text(
              '訂閱新聞類別',
              style: TextStyle(
                color: appColor,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: appColor,), 
              onPressed: () {
                _showUnsubscriptionDialog(context, categoryList, personalPageBloc);
              }
            ),
          ],
        ),
        SizedBox(height: 4),
        categoryList.subscriptionCount == 0
        ? Container()
        : Container(
            height: 32,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      if (index == 0) SizedBox(width: 8.0),
                      if(categoryList[index].isSubscribed)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular((15.0)),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: appColor, width: 1),
                                borderRadius: BorderRadius.circular((15.0)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(categoryList[index].title),
                                    if(categoryList[index].id != focusSectionKey)
                                    ...[
                                      SizedBox(width: 4.0),
                                      Icon(
                                        Icons.remove_circle_outline,
                                        size: 18,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              if(categoryList[index].id != focusSectionKey) {
                                categoryList[index].isSubscribed =
                                    !categoryList[index].isSubscribed;
                                personalPageBloc
                                    .setCategoryListInStorage(categoryList);
                              }
                            },
                          ),
                        ),
                    ],
                  );
                }),
          ),
      ],
    );
  }

  _showUnsubscriptionDialog(BuildContext context, CategoryList categoryList, PersonalPageBloc personalPageBloc){
    var contentHeight = MediaQuery.of(context).size.height/3;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        StreamController<CategoryList> controller = StreamController<CategoryList>();
        return AlertDialog(
          title: Text('新增訂閱項目'),
          content: Container(
            width: double.maxFinite,
            height: contentHeight,
            child: UnsubscriptionCategoryList(
              controller: controller,
              categoryList: categoryList,
              personalPageBloc: personalPageBloc,
            ),
          ),
          actions: [
            FlatButton(
              child: Text("完成", style: TextStyle(color: Colors.black),),
              onPressed:(){
                controller.close();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _buildSubscribtoinList(
      BuildContext context, RecordList recordList, Status status) {
    var width = MediaQuery.of(context).size.width;
    double imageSize = 25 * (width - 32) / 100;

    // VerticalDivider is broken? so use Container
    var myVerticalDivider = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        color: appColor,
        width: 2,
        height: 20,
      ),
    );

    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        myVerticalDivider,
        Text(
          '訂閱的文章',
          style: TextStyle(
            color: appColor,
            fontSize: 20,
          ),
        ),
        myVerticalDivider,
      ]),
      ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recordList == null ? 0 : recordList.length,
          itemBuilder: (context, index) {
            Record record = recordList[index];
            return Column(
              children: [
                _buildListItem(record, imageSize),
                if (index == recordList.length - 1 &&
                    status == Status.LOADINGMORE)
                  CupertinoActivityIndicator(),
              ],
            );
          }),
    ]);
  }

  _buildListItem(Record record, double imageSize) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    record.title,
                    style: TextStyle(fontSize: 20),
                  ),
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage(slug: record.slug)));
      },
    );
  }
}
