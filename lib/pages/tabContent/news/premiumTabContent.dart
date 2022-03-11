import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/editorChoice/cubit.dart';
import 'package:readr_app/blocs/editorChoice/state.dart';
import 'package:readr_app/blocs/tabContentBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
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
  late TabContentBloc _tabContentBloc;

  @override
  void initState() {
    _tabContentBloc = TabContentBloc(
      widget.section.sectionAd,
      widget.section.key, 
      widget.section.type, 
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabContentBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _tabContentBloc.refreshTheList(widget.section.key, widget.section.type);
      },
      child: _buildTabContentBody(),
    );
  }

  Widget _buildTabContentBody() {
    return StreamBuilder<ApiResponse<TabContentState>>(
      stream: _tabContentBloc.recordListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TabContentState? tabContentState = snapshot.data!.data;

          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              List<Record> recordList = tabContentState == null
                  ? _tabContentBloc.records
                  : tabContentState.recordList;

              return _buildTheRecordList(
                context, 
                recordList,
                snapshot.data!.status, 
                _tabContentBloc
              );

            case Status.ERROR:
              return ErrorStatelessWidget(
                errorMessage: snapshot.data!.message!,
                onRetryPressed: () => _tabContentBloc.fetchRecordList(),
              );
          }
        }
        return Container();
      },
    );
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
    BuildContext context, 
    List<Record> recordList,
    Status status, 
    TabContentBloc tabContentBloc
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
              tabContentBloc.loadingMore(index);
              
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
                      status == Status.LOADINGMORE)
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