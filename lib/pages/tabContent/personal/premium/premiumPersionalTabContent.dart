import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';

import 'package:readr_app/blocs/personalPage/category/bloc.dart';
import 'package:readr_app/blocs/personalPage/category/events.dart';
import 'package:readr_app/blocs/personalPage/category/states.dart';

import 'package:readr_app/blocs/personalPage/article/bloc.dart';
import 'package:readr_app/blocs/personalPage/article/events.dart';
import 'package:readr_app/blocs/personalPage/article/states.dart';
import 'package:readr_app/pages/tabContent/personal/premium/premiumMemberSubscriptionTypeBlock.dart';
import 'package:readr_app/pages/tabContent/personal/premium/premiumUnsubscriptionCategoryList.dart';
import 'package:readr_app/pages/tabContent/shared/premiumListItem.dart';

import 'package:readr_app/services/categoryService.dart';
import 'package:readr_app/services/personalSubscriptionService.dart';

import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarqueePersistentHeaderDelegate.dart';

class PremiumPersonalTabContent extends StatefulWidget {
  final ScrollController scrollController;
  PremiumPersonalTabContent({
    required this.scrollController,
  });

  @override
  _PremiumPersonalTabContentState createState() => _PremiumPersonalTabContentState();
}

class _PremiumPersonalTabContentState extends State<PremiumPersonalTabContent> {
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
        BlocProvider(
          create: (context) => _personalCategoryBloc
        ),
        BlocProvider(
          create: (context) => PersonalArticleBloc(
            personalSubscriptionRepos: PersonalSubscriptionService(),
          ),
        ),
      ],
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          if(!_remoteConfigHelper.isNewsMarqueePin)
            SliverPersistentHeader(
              delegate: NewsMarqueePersistentHeaderDelegate(),
              floating: true,
            ),
          SliverToBoxAdapter(
            child: BlocProvider(
              create: (BuildContext context) => MemberSubscriptionTypeCubit(),
              child: PremiumMemberSubscriptionTypeBlock(),
            ),
          ),
          
          _buildSubscribedCategoryList(),
          _buildTabContent(),
        ],
      ),
    );
  }

  _buildSubscribedCategoryList() {
    return BlocBuilder<PersonalCategoryBloc, PersonalCategoryState>(
      builder: (BuildContext context, PersonalCategoryState state) {
        PersonalCategoryStatus status = state.status;
        if(status == PersonalCategoryStatus.initial) {
          context.read<PersonalCategoryBloc>().add(FetchSubscribedCategoryList());
        }

        if(status == PersonalCategoryStatus.subscribedCategoryListLoading) {
          return SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if(status == PersonalCategoryStatus.subscribedCategoryListLoaded) {
          _subscribedCategoryList = state.subscribedCategoryList!;
          context.read<PersonalArticleBloc>().add(FetchSubscribedArticleList(
            _subscribedCategoryList
          ));

          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: _buildCategoryList(context, _subscribedCategoryList),
            ),
          );
        }

        if(status == PersonalCategoryStatus.subscribedCategoryListLoadingError) {
          return SliverToBoxAdapter(
            child: Container()
          );      
        }

        return SliverToBoxAdapter(
          child: Container()
        );
      }
    );
  }

  _showUnsubscriptionDialog(){
    double height = MediaQuery.of(context).size.height;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  height: height/1.5,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 13.0,right: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PremiumUnsubscriptionCategoryList(
                      personalCategoryBloc: _personalCategoryBloc
                    ),
                  ),
                ),
                Positioned(
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: appColor,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }
    );
  }

  Widget _buildCategoryChip({
    String title = '', 
    Color backgroundColor = appColor,
    Icon icon = const Icon(
      Icons.remove_circle_outline,
      size: 18,
      color: Colors.white
    ),
    GestureTapCallback? onTap
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular((10.0)),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular((10.0)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 4.0),
              icon
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildCategoryList(
    BuildContext context, 
    List<Category> categoryList
  ) {
    return Column(
      key: _categoryKey,
      children: [
        Text(
          '訂閱新聞類別',
          style: TextStyle(
            color: appColor,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              if(index != 0 && !categoryList[index].isSubscribed) {
                return Container();
              }

              return Row(
                children: [
                  if(index == 0)...[
                    SizedBox(width: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildCategoryChip(
                        title: '新增',
                        backgroundColor: Color(0xff7C7C7C),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        onTap: () {
                          _showUnsubscriptionDialog();
                        }
                      ),
                    ),
                  ],

                  if(categoryList[index].isSubscribed)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildCategoryChip(
                        title: categoryList[index].title,
                        onTap: () {
                          categoryList[index].isSubscribed =
                              !categoryList[index].isSubscribed;
                          context.read<PersonalCategoryBloc>().add(
                            SetCategoryListInStorage(categoryList)
                          );
                        }
                      ),
                    ),
                ]
              );
            }
          ),
        ),
      ],
    );
  }

  _buildTabContent() {
    return BlocConsumer<PersonalArticleBloc, PersonalArticleState>(
      listener: (BuildContext context, PersonalArticleState state) async{
        PersonalArticleStatus status = state.status;
        if(status == PersonalArticleStatus.subscribedArticleListLoadingMoreFail) {
          await Future.delayed(Duration(seconds: 3));
          context.read<PersonalArticleBloc>().add(FetchNextPageSubscribedArticleList(
            _subscribedCategoryList
          ));
        }
      },
      builder: (BuildContext context, PersonalArticleState state) {
        PersonalArticleStatus status = state.status;
        if(status == PersonalArticleStatus.subscribedArticleListLoadingError) {
          return SliverToBoxAdapter(
            child: Container()
          );
        }

        if(status == PersonalArticleStatus.subscribedArticleListLoading) {
          return SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if(status == PersonalArticleStatus.subscribedArticleListLoaded) {
          List<Record> subscribedArticleList = state.subscribedArticleList!;
          if(subscribedArticleList.length == 0) {
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
                if(!context.read<PersonalArticleBloc>().isNextPageEmpty &&
                  index == subscribedArticleList.length - 5) {
                  context.read<PersonalArticleBloc>().add(FetchNextPageSubscribedArticleList(
                    _subscribedCategoryList
                  ));
                }

                return _buildSubscribtoinList(context, subscribedArticleList, index);
              },
              childCount: subscribedArticleList.length,
            ),
          );
        }

        if(status == PersonalArticleStatus.subscribedArticleListLoadingMore) {
          List<Record> subscribedArticleList = state.subscribedArticleList!;

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if(index == subscribedArticleList.length -1) {
                  return Column(
                    children: [
                      _buildSubscribtoinList(context, subscribedArticleList, index),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child:  Center(child: CupertinoActivityIndicator()),
                      ),
                    ]
                  );
                }
                
                return _buildSubscribtoinList(context, subscribedArticleList, index);
              },
              childCount: subscribedArticleList.length,
            ),
          );
        }
        
        if(status == PersonalArticleStatus.subscribedArticleListLoadingMoreFail) {
          Fluttertoast.showToast(
            msg: '加載更多失敗',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
          
          List<Record> subscribedArticleList = state.subscribedArticleList!;

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {                
                return _buildSubscribtoinList(context, subscribedArticleList, index);
              },
              childCount: subscribedArticleList.length,
            ),
          );
        }

        // initial
        return SliverToBoxAdapter(
          child: Container()
        );
      }
    );
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
        if(index == 0) 
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 18.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: PremiumListItem(
            record: record,
            onTap: () => RouteGenerator.navigateToStory(
                record.slug, 
                isMemberCheck: record.isMemberCheck, 
                isMemberContent: record.isMemberContent),
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}