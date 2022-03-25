import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/blocs/editorChoice/cubit.dart';
import 'package:readr_app/blocs/editorChoice/state.dart';
import 'package:readr_app/blocs/tabContent/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/pages/tabContent/shared/listItem.dart';
import 'package:readr_app/pages/tabContent/shared/theFirstItem.dart';
import 'package:readr_app/services/editorChoiceService.dart';
import 'package:readr_app/widgets/editorChoiceCarousel.dart';
import 'package:readr_app/widgets/errorStatelessWidget.dart';
import 'package:readr_app/widgets/mMAdBanner.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarqueePersistentHeaderDelegate.dart';

class TabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  final bool needCarousel;
  TabContent({
    required this.section,
    required this.scrollController,
    this.needCarousel = false,
  });

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  late SectionAd? _sectionAd;
  
  _fetchFirstRecordList() {
    context.read<TabContentBloc>().add(
      FetchFirstRecordList(
        sectionKey: widget.section.key, 
        sectionType: widget.section.type
      )
    );
  }

  _fetchNextPageRecordList() {
    context.read<TabContentBloc>().add(
      FetchNextPageRecordList()
    );
  }

  @override
  void initState() {
    _sectionAd = widget.section.sectionAd;
    _fetchFirstRecordList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        _fetchFirstRecordList();
      },
      child: Column(
        children: [
          // if(widget.section.title == '會員專區') Container(
          // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 37.5),
          // child: Image.asset(subscribeBannerJpg),
          // ),
          Expanded(
            child: BlocBuilder<TabContentBloc, TabContentState>(
              builder: (BuildContext context, TabContentState state) {
                switch (state.status) {
                  case TabContentStatus.loadingError:
                    final error = state.errorMessages;
                    print('TabContent: ${error.message}');
                    return ErrorStatelessWidget(
                      errorMessage: error.message,
                      onRetryPressed: () => _fetchFirstRecordList(),
                    );
                  case TabContentStatus.loaded:
                  case TabContentStatus.loadingMore:
                    List<Record> recordList = state.recordList!;

                    return _buildTheRecordList(
                      recordList,
                      hasNextPage: state.hasNextPage!,
                      isLoadingMore: state.status == TabContentStatus.loadingMore
                    );
                  case TabContentStatus.loadingMoreFail:
                    Fluttertoast.showToast(
                      msg: '加載更多失敗',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                    List<Record> recordList = state.recordList!;

                    return _buildTheRecordList(
                      recordList,
                    );
                  default:
                    // state is Init, Loading
                    return _loadingWidget();
                }
              }
            ),
          ),
          if(isTabContentAdsActivated && 
            _sectionAd != null)
            MMAdBanner(
              adUnitId: _sectionAd!.stUnitId,
              adSize: AdSize.banner,
            ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _buildEditorChoiceList() {
    return BlocProvider(
      create: (BuildContext context) => EditorChoiceCubit(editorChoiceRepos: EditorChoiceService()),
      child: BlocBuilder<EditorChoiceCubit, EditorChoiceState>(
        builder: (context, state) {
          if(state.status == EditorChoiceStatus.initial) {
            context.read<EditorChoiceCubit>().fetchEditorChoiceRecordList();
          } else if(state.status == EditorChoiceStatus.loaded) {
            List<Record> editorChoiceList = state.editorChoiceList!;
            
            return EditorChoiceCarousel(
              editorChoiceList: editorChoiceList,
              aspectRatio: 16 / 10,
            );
          } else if(state.status == EditorChoiceStatus.error) {
            print('NewsMarquee error: ${state.errorMessages}');
          }

          return Container();
        }
      ),
    );
  }

  Widget _buildTheRecordList(
    List<Record> recordList,
    {
      bool hasNextPage = true, 
      bool isLoadingMore = false,
    }
  ) {
    
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if(!_remoteConfigHelper.isNewsMarqueePin)
          SliverPersistentHeader(
            delegate: NewsMarqueePersistentHeaderDelegate(),
            floating: true,
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if(hasNextPage && 
                !isLoadingMore && 
                index == recordList.length-1) {
                _fetchNextPageRecordList();
              }
              
              if (index == 0) {
                if(widget.needCarousel) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditorChoiceList(),
                      if(isTabContentAdsActivated && _sectionAd != null)
                      ...[
                        SizedBox(height: 16.0,),
                        // carouselAT1AdIndex
                        Center(
                          child: MMAdBanner(
                            adUnitId: _sectionAd!.aT1UnitId,
                            adSize: AdSize.mediumRectangle,
                          ),
                        ),
                      ],
                      SizedBox(height: 16.0,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: _buildTagText(),
                      ),
                      SizedBox(height: 8.0,),
                      ListItem(
                        record: recordList[index],
                        onTap: () => RouteGenerator.navigateToStory(
                            recordList[index].slug, 
                            isMemberCheck: recordList[index].isMemberCheck),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ]
                  );
                }
                // if(!widget.needCarousel)
                return TheFirstItem(
                  record: recordList[index],
                  onTap: () => RouteGenerator.navigateToStory(
                      recordList[index].slug, 
                      isMemberCheck: recordList[index].isMemberCheck),
                );
              }

              return Column(
                children: [
                  if(isTabContentAdsActivated && _sectionAd != null &&
                    index == noCarouselAT1AdIndex && !widget.needCarousel)
                    MMAdBanner(
                      adUnitId: _sectionAd!.aT1UnitId,
                      adSize: AdSize.mediumRectangle,
                    ),
                  ListItem(
                    record: recordList[index],
                    onTap: () => RouteGenerator.navigateToStory(
                        recordList[index].slug, 
                        isMemberCheck: recordList[index].isMemberCheck),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  if(isTabContentAdsActivated && _sectionAd != null &&
                    index == carouselAT2AdIndex && widget.needCarousel) 
                    MMAdBanner(
                      adUnitId: _sectionAd!.aT2UnitId,
                      adSize: AdSize.mediumRectangle,
                    ),
                  if(isTabContentAdsActivated && _sectionAd != null &&
                    index == noCarouselAT2AdIndex && !widget.needCarousel) 
                    MMAdBanner(
                      adUnitId: _sectionAd!.aT2UnitId,
                      adSize: AdSize.mediumRectangle,
                    ),
                    
                  if(isTabContentAdsActivated && _sectionAd != null &&
                    index == carouselAT3AdIndex && widget.needCarousel) 
                    MMAdBanner(
                      adUnitId: _sectionAd!.aT3UnitId,
                      adSize: AdSize.mediumRectangle,
                    ),
                  if(isTabContentAdsActivated && _sectionAd != null &&
                    index == noCarouselAT3AdIndex && !widget.needCarousel) 
                    MMAdBanner(
                      adUnitId: _sectionAd!.aT3UnitId,
                      adSize: AdSize.mediumRectangle,
                    ),

                  if (index == recordList.length - 1 &&
                      isLoadingMore)
                    _loadMoreWidget(),
                ],
              );
            },
            childCount: recordList.length
          ),
        ),
      ],
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

  Widget _buildTagText() {
    return Text(
      '最新文章',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: appColor,
      ),
    );
  }
}
