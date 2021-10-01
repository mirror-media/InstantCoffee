import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/blocs/personalPageBloc.dart';
import 'package:readr_app/blocs/tabContent/personal/cubit.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/categoryList.dart';
import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/pages/tabContent/personal/memberSubscriptionTypeBlock.dart';
import 'package:readr_app/widgets/unsubscriptionCategoryList.dart';

class PersonalTabContent extends StatefulWidget {
  final OnBoardingBloc onBoardingBloc;
  final ScrollController scrollController;
  PersonalTabContent({
    @required this.onBoardingBloc,
    @required this.scrollController,
  });

  @override
  _PersonalTabContentState createState() => _PersonalTabContentState();
}

class _PersonalTabContentState extends State<PersonalTabContent> {
  GlobalKey _categoryKey;
  PersonalPageBloc _personalPageBloc;

  @override
  void initState() {
    _categoryKey = GlobalKey();
    _personalPageBloc = PersonalPageBloc();

    super.initState();
  }

  @override
  void dispose() {
    _personalPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<CategoryList>>(
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
              WidgetsBinding.instance.addPostFrameCallback((_) async{
                //await Future.delayed(Duration(milliseconds: 500));
                if(widget.onBoardingBloc.isOnBoarding && 
                widget.onBoardingBloc.status == OnBoardingStatus.SecondPage) {
                  OnBoarding onBoarding = await widget.onBoardingBloc.getSizeAndPosition(_categoryKey);
                  onBoarding.left = 0;
                  onBoarding.height += 16;
                  onBoarding.isNeedInkWell = true;
                  

                  widget.onBoardingBloc.checkOnBoarding(onBoarding);
                  widget.onBoardingBloc.status = OnBoardingStatus.ThirdPage;
                }
              });
              return _buildPersonalTabContent(widget.scrollController, context, categoryList, _personalPageBloc);
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

  Widget _buildPersonalTabContent(
      ScrollController scrollController, 
      BuildContext context, 
      CategoryList categoryList, 
      PersonalPageBloc personalPageBloc) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: BlocProvider(
            create: (BuildContext context) => MemberSubscriptionTypeCubit(),
            child: MemberSubscriptionTypeBlock(),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildCategoryList(context, categoryList, _personalPageBloc),
        ),
        SliverToBoxAdapter(
          child: Divider(
            height: 32,
            thickness: 1.5,
            color: Colors.black,
          ),
        ),
        StreamBuilder<ApiResponse<RecordList>>(
          stream: _personalPageBloc.personalSubscriptionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                  break;

                case Status.LOADINGMORE:
                case Status.COMPLETED:
                  RecordList recordList = snapshot.data.data == null
                      ? _personalPageBloc.recordList
                      : snapshot.data.data;
                  Status status = snapshot.data.status;
                  if(recordList == null || recordList.length == 0) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Center(
                            child: Text(
                              '目前沒有訂閱的新聞類別',
                              style: TextStyle(
                                color: appColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '點上方按鈕進行訂閱！',
                              style: TextStyle(
                                color: appColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        _personalPageBloc.loadingMore(index);

                        return _buildSubscribtoinList(context, recordList, index, status);
                      },
                      childCount: recordList == null ? 0 : recordList.length,
                    ),
                  );
                  break;

                case Status.ERROR:
                  return SliverToBoxAdapter(
                    child: Container(),
                  );
                  break;
              }
            }
            return SliverToBoxAdapter(
              child: Container(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryList(
      BuildContext context, CategoryList categoryList, PersonalPageBloc personalPageBloc) {
    return Column(
      key: _categoryKey,
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
                                    Text(categoryList[index].title),                                                                         SizedBox(width: 4.0),
                                    Icon(
                                      Icons.remove_circle_outline,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              categoryList[index].isSubscribed =
                                  !categoryList[index].isSubscribed;
                              personalPageBloc
                                  .setCategoryListInStorage(categoryList);
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
      BuildContext context, RecordList recordList, int index, Status status) {
    Record record = recordList[index];
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

    return Column(
      children: [
        if(index == 0) 
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
        _buildListItem(record, imageSize),
        if (index == recordList.length - 1 &&
            status == Status.LOADINGMORE)
          CupertinoActivityIndicator(),
      ],
    );
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
      onTap: () => RouteGenerator.navigateToStory(context, record.slug, isMemberCheck: record.isMemberCheck),
    );
  }
}