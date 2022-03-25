import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/editorChoice/cubit.dart';
import 'package:readr_app/blocs/editorChoice/state.dart';
import 'package:readr_app/blocs/tabContent/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/tabContent/shared/premiumListItem.dart';
import 'package:readr_app/pages/tabContent/shared/theFirstItem.dart';
import 'package:readr_app/services/editorChoiceService.dart';
import 'package:readr_app/widgets/editorChoiceCarousel.dart';
import 'package:readr_app/widgets/errorStatelessWidget.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarqueePersistentHeaderDelegate.dart';

class PremiumTabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  final bool needCarousel;
  PremiumTabContent({
    required this.section,
    required this.scrollController,
    this.needCarousel = false,
  });

  @override
  _PremiumTabContentState createState() => _PremiumTabContentState();
}

class _PremiumTabContentState extends State<PremiumTabContent> {
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();

  _fetchRecordList() {
    context.read<TabContentBloc>().add(
      FetchRecordList(
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
    _fetchRecordList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        _fetchRecordList();
      },
      child: BlocBuilder<TabContentBloc, TabContentState>(
        builder: (BuildContext context, TabContentState state) {
          switch (state.status) {
            case TabContentStatus.loadingError:
              final error = state.errorMessages;
              print('TabContent: ${error.message}');
              return ErrorStatelessWidget(
                errorMessage: error.message,
                onRetryPressed: () => _fetchRecordList(),
              );
            case TabContentStatus.loaded:
            case TabContentStatus.loadingMore:
              List<Record> recordList = state.recordList!;

              return _buildTheRecordList(
                recordList,
                hasNextPage: state.hasNextPage!,
                isLoadingMore: state.status == TabContentStatus.loadingMore
              );
            default:
              // state is Init, Loading
              return _loadingWidget();
          }
        }
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
                      _buildTagText(),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                        child: PremiumListItem(
                          record: recordList[index],
                          onTap: () => RouteGenerator.navigateToStory(
                              recordList[index].slug, 
                              isMemberCheck: recordList[index].isMemberCheck),
                        )
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ]
                  );
                }

                return TheFirstItem(
                  record: recordList[index],
                  onTap: () => RouteGenerator.navigateToStory(
                      recordList[index].slug, 
                      isMemberCheck: recordList[index].isMemberCheck),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                    child: PremiumListItem(
                      record: recordList[index],
                      onTap: () => RouteGenerator.navigateToStory(
                          recordList[index].slug, 
                          isMemberCheck: recordList[index].isMemberCheck),
                    )
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
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
    return Container(
      color: appColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Center(
          child: Text(
            '最新文章',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}