import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/blocs/personalPageBloc.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/OnBoardingPosition.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/pages/tabContent/personal/memberSubscriptionTypeBlock.dart';
import 'package:readr_app/pages/tabContent/shared/listItem.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarqueePersistentHeaderDelegate.dart';
import 'package:readr_app/pages/tabContent/personal/default/unsubscriptionCategoryList.dart';

class PersonalTabContent extends StatefulWidget {
  final ScrollController scrollController;
  PersonalTabContent({
    required this.scrollController,
  });

  @override
  _PersonalTabContentState createState() => _PersonalTabContentState();
}

class _PersonalTabContentState extends State<PersonalTabContent> {
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  GlobalKey _categoryKey = GlobalKey();
  PersonalPageBloc _personalPageBloc = PersonalPageBloc();

  @override
  void dispose() {
    _personalPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<List<Category>>>(
      stream: _personalPageBloc.categoryStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              List<Category> categoryList = snapshot.data!.data!;
              WidgetsBinding.instance!.addPostFrameCallback((_) async{
                OnBoardingBloc onBoardingBloc = context.read<OnBoardingBloc>();
                if(onBoardingBloc.state.status == OnBoardingStatus.firstPage) {
                  OnBoardingPosition onBoardingPosition = await onBoardingBloc.getSizeAndPosition(_categoryKey);
                  onBoardingPosition.left = 0;
                  onBoardingPosition.height += 16;
                  
                  onBoardingBloc.add(
                    GoToNextHint(
                      onBoardingStatus: OnBoardingStatus.secondPage,
                      onBoardingPosition: onBoardingPosition,
                    )
                  );
                }
              });
              return _buildPersonalTabContent(widget.scrollController, context, categoryList, _personalPageBloc);

            case Status.ERROR:
              return Container();
          }
        }
        return Container();
      },
    );
  }

  Widget _buildPersonalTabContent(
      ScrollController scrollController, 
      BuildContext context, 
      List<Category> categoryList, 
      PersonalPageBloc personalPageBloc) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        if(!_remoteConfigHelper.isNewsMarqueePin)
          SliverPersistentHeader(
            delegate: NewsMarqueePersistentHeaderDelegate(),
            floating: true,
          ),
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
        StreamBuilder<ApiResponse<List<Record>>>(
          stream: _personalPageBloc.personalSubscriptionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );

                case Status.LOADINGMORE:
                case Status.COMPLETED:
                  List<Record> recordList = snapshot.data!.data == null
                      ? _personalPageBloc.recordList
                      : snapshot.data!.data!;
                  Status status = snapshot.data!.status;
                  if(recordList.length == 0) {
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
                      childCount: recordList.length,
                    ),
                  );

                case Status.ERROR:
                  return SliverToBoxAdapter(
                    child: Container(),
                  );
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
      BuildContext context, List<Category> categoryList, PersonalPageBloc personalPageBloc) {
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
        Category.subscriptionCountInCategoryList(categoryList) == 0
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

  _showUnsubscriptionDialog(BuildContext context, List<Category> categoryList, PersonalPageBloc personalPageBloc){
    var contentHeight = MediaQuery.of(context).size.height/3;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        StreamController<List<Category>> controller = StreamController<List<Category>>();
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
            TextButton(
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
      BuildContext context, List<Record> recordList, int index, Status status) {
    Record record = recordList[index];

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
        ListItem(
          record: record,
          onTap: () => RouteGenerator.navigateToStory(
              record.slug, 
              isMemberCheck: record.isMemberCheck, 
              isMemberContent: record.isMemberContent),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        if (index == recordList.length - 1 &&
            status == Status.LOADINGMORE)
          CupertinoActivityIndicator(),
      ],
    );
  }
}