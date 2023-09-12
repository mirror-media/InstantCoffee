import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/listening_tab_content_bloc.dart';
import 'package:readr_app/helpers/api_response.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/tabContent/shared/premium_list_item.dart';
import 'package:readr_app/pages/tabContent/shared/the_first_item.dart';
import 'package:readr_app/widgets/error_stateless_widget.dart';
import 'package:readr_app/widgets/newsMarquee/news_marquee_persistent_header_delegate.dart';

class PremiumListeningTabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  const PremiumListeningTabContent({
    required this.section,
    required this.scrollController,
  });

  @override
  _PremiumListeningTabContentState createState() =>
      _PremiumListeningTabContentState();
}

class _PremiumListeningTabContentState
    extends State<PremiumListeningTabContent> {
  final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  late ListeningTabContentBloc _listeningTabContentBloc;

  @override
  void initState() {
    _listeningTabContentBloc =
        ListeningTabContentBloc(widget.section.sectionAd!);
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        // 滾動到底部，觸發加載操作
        _listeningTabContentBloc.loadingMore();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _listeningTabContentBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _listeningTabContentBloc.refreshTheList();
      },
      child: _buildListeningTabContentBody(),
    );
  }

  Widget _buildListeningTabContentBody() {
    return StreamBuilder<ApiResponse<List<Record>>>(
      stream: _listeningTabContentBloc.listeningTabContentStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              List<Record> recordList = snapshot.data!.data == null
                  ? _listeningTabContentBloc.records
                  : snapshot.data!.data!;

              return _buildTheRecordList(context, _listeningTabContentBloc,
                  recordList, snapshot.data!.status);

            case Status.ERROR:
              return ErrorStatelessWidget(
                errorMessage: snapshot.data!.message!,
                onRetryPressed: () =>
                    _listeningTabContentBloc.fetchRecordList(),
              );
          }
        }
        return Container();
      },
    );
  }

  Widget _buildTheRecordList(
      BuildContext context,
      ListeningTabContentBloc listeningTabContentBloc,
      List<Record> recordList,
      Status status) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if (!_remoteConfigHelper.isNewsMarqueePin)
          SliverPersistentHeader(
            delegate: NewsMarqueePersistentHeaderDelegate(),
            floating: true,
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {

              if (index == 0) {
                return TheFirstItem(
                  record: recordList[index],
                  onTap: () => RouteGenerator.navigateToListeningStory(
                      recordList[index].slug),
                );
              }

              return Column(
                children: [

                  Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                      child: PremiumListItem(
                        record: recordList[index],
                        onTap: () => RouteGenerator.navigateToListeningStory(
                            recordList[index].slug),
                      )),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  if (index == recordList.length - 1 &&
                      status == Status.LOADINGMORE)
                    const CupertinoActivityIndicator(),
                ],
              );
            },
            childCount: recordList.length,
          ),
        ),
      ],
    );
  }
}
