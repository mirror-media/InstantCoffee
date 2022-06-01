import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/blocs/onBoarding/events.dart';
import 'package:readr_app/blocs/onBoarding/states.dart';

import 'package:readr_app/blocs/personalPage/category/bloc.dart';
import 'package:readr_app/blocs/personalPage/category/events.dart';
import 'package:readr_app/blocs/personalPage/category/states.dart';

import 'package:readr_app/blocs/personalPage/article/bloc.dart';
import 'package:readr_app/blocs/personalPage/article/events.dart';
import 'package:readr_app/blocs/personalPage/article/states.dart';
import 'package:readr_app/helpers/adHelper.dart';
import 'package:readr_app/models/OnBoardingPosition.dart';
import 'package:readr_app/pages/tabContent/personal/default/unsubscriptionCategoryList.dart';

import 'package:readr_app/services/categoryService.dart';
import 'package:readr_app/services/personalSubscriptionService.dart';

import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/pages/tabContent/personal/default/memberSubscriptionTypeBlock.dart';
import 'package:readr_app/pages/tabContent/shared/listItem.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarqueePersistentHeaderDelegate.dart';

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

  List<Category> _subscribedCategoryList = [];
  PersonalCategoryBloc _personalCategoryBloc = PersonalCategoryBloc(
    categoryRepos: CategoryService(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _personalCategoryBloc),
        BlocProvider(
          create: (context) => PersonalArticleBloc(
            personalSubscriptionRepos: PersonalSubscriptionService(),
          ),
        ),
      ],
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          if (!_remoteConfigHelper.isNewsMarqueePin)
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
          _buildSubscribedCategoryList(),
          _buildTabContent(),
        ],
      ),
    );
  }

  _buildSubscribedCategoryList() {
    return BlocConsumer<PersonalCategoryBloc, PersonalCategoryState>(
        listener: (BuildContext context, PersonalCategoryState state) {
      PersonalCategoryStatus status = state.status;
      if (status == PersonalCategoryStatus.subscribedCategoryListLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          OnBoardingBloc onBoardingBloc = context.read<OnBoardingBloc>();
          if (onBoardingBloc.state.status == OnBoardingStatus.firstPage) {
            OnBoardingPosition onBoardingPosition =
                await onBoardingBloc.getSizeAndPosition(_categoryKey);
            onBoardingPosition.left = 0;
            onBoardingPosition.height += 16;

            onBoardingBloc.add(GoToNextHint(
              onBoardingStatus: OnBoardingStatus.secondPage,
              onBoardingPosition: onBoardingPosition,
            ));
          }
        });
      }
    }, builder: (BuildContext context, PersonalCategoryState state) {
      PersonalCategoryStatus status = state.status;
      if (status == PersonalCategoryStatus.initial) {
        context.read<PersonalCategoryBloc>().add(FetchSubscribedCategoryList());
      }

      if (status == PersonalCategoryStatus.subscribedCategoryListLoading) {
        return SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (status == PersonalCategoryStatus.subscribedCategoryListLoaded) {
        _subscribedCategoryList = state.subscribedCategoryList!;
        context
            .read<PersonalArticleBloc>()
            .add(FetchSubscribedArticleList(_subscribedCategoryList));

        return SliverList(
          delegate: SliverChildListDelegate(
            [
              _buildCategoryList(context, _subscribedCategoryList),
              Divider(
                height: 32,
                thickness: 1.5,
                color: Colors.black,
              ),
            ],
          ),
        );
      }

      if (status == PersonalCategoryStatus.subscribedCategoryListLoadingError) {
        return SliverToBoxAdapter(child: Container());
      }

      return SliverToBoxAdapter(child: Container());
    });
  }

  _showUnsubscriptionDialog() {
    var contentHeight = MediaQuery.of(context).size.height / 3;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('新增訂閱項目'),
              content: Container(
                width: double.maxFinite,
                height: contentHeight,
                child: UnsubscriptionCategoryList(
                    personalCategoryBloc: _personalCategoryBloc),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "完成",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categoryList) {
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
                icon: Icon(
                  Icons.add_circle_outline,
                  color: appColor,
                ),
                onPressed: () {
                  _showUnsubscriptionDialog();
                }),
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
                          if (categoryList[index].isSubscribed)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular((15.0)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: appColor, width: 1),
                                    borderRadius: BorderRadius.circular((15.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 4.0, 8.0, 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(categoryList[index].title),
                                        SizedBox(width: 4.0),
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
                                  context.read<PersonalCategoryBloc>().add(
                                      SetCategoryListInStorage(categoryList));
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

  _buildTabContent() {
    return BlocConsumer<PersonalArticleBloc, PersonalArticleState>(
        listener: (BuildContext context, PersonalArticleState state) async {
      PersonalArticleStatus status = state.status;
      if (status ==
          PersonalArticleStatus.subscribedArticleListLoadingMoreFail) {
        await Future.delayed(Duration(seconds: 3));
        context
            .read<PersonalArticleBloc>()
            .add(FetchNextPageSubscribedArticleList(_subscribedCategoryList));
      }
    }, builder: (BuildContext context, PersonalArticleState state) {
      PersonalArticleStatus status = state.status;
      if (status == PersonalArticleStatus.subscribedArticleListLoadingError) {
        return SliverToBoxAdapter(child: Container());
      }

      if (status == PersonalArticleStatus.subscribedArticleListLoading) {
        return SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (status == PersonalArticleStatus.subscribedArticleListLoaded) {
        List<Record> subscribedArticleList = state.subscribedArticleList!;
        if (subscribedArticleList.length == 0) {
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
              if (!context.read<PersonalArticleBloc>().isNextPageEmpty &&
                  index == subscribedArticleList.length - 5) {
                context.read<PersonalArticleBloc>().add(
                    FetchNextPageSubscribedArticleList(
                        _subscribedCategoryList));
              }

              return _buildSubscribtoinList(
                  context, subscribedArticleList, index);
            },
            childCount: subscribedArticleList.length,
          ),
        );
      }

      if (status == PersonalArticleStatus.subscribedArticleListLoadingMore) {
        List<Record> subscribedArticleList = state.subscribedArticleList!;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index == subscribedArticleList.length - 1) {
                return Column(children: [
                  _buildSubscribtoinList(context, subscribedArticleList, index),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Center(child: CupertinoActivityIndicator()),
                  ),
                ]);
              }

              return _buildSubscribtoinList(
                  context, subscribedArticleList, index);
            },
            childCount: subscribedArticleList.length,
          ),
        );
      }

      if (status ==
          PersonalArticleStatus.subscribedArticleListLoadingMoreFail) {
        Fluttertoast.showToast(
            msg: '加載更多失敗',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        List<Record> subscribedArticleList = state.subscribedArticleList!;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildSubscribtoinList(
                  context, subscribedArticleList, index);
            },
            childCount: subscribedArticleList.length,
          ),
        );
      }

      // initial
      return SliverToBoxAdapter(child: Container());
    });
  }

  _buildSubscribtoinList(
      BuildContext context, List<Record> recordList, int index) {
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
        if (index == 0)
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
            onTap: () {
              AdHelper adHelper = AdHelper();
              adHelper.checkToShowInterstitialAd();

              RouteGenerator.navigateToStory(
                record.slug,
                isMemberCheck: record.isMemberCheck,
                url: record.url,
              );
            }),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
