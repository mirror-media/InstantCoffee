import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/listeningTabContentBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/tabContent/shared/premiumListItem.dart';
import 'package:readr_app/pages/tabContent/shared/theFirstItem.dart';
import 'package:readr_app/widgets/errorStatelessWidget.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarqueePersistentHeaderDelegate.dart';

class PremiumListeningTabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  PremiumListeningTabContent({
    required this.section,
    required this.scrollController,
  });

  @override
  _PremiumListeningTabContentState createState() => _PremiumListeningTabContentState();
}

class _PremiumListeningTabContentState extends State<PremiumListeningTabContent> {
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  late ListeningTabContentBloc _listeningTabContentBloc;

  @override
  void initState() {
    _listeningTabContentBloc = ListeningTabContentBloc(widget.section.sectionAd!);
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
              return Center(child: CircularProgressIndicator());

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              List<Record> recordList = snapshot.data!.data == null
                  ? _listeningTabContentBloc.records
                  : snapshot.data!.data!;

              return _buildTheRecordList(
                  context, _listeningTabContentBloc, recordList, snapshot.data!.status);

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
      BuildContext context, ListeningTabContentBloc listeningTabContentBloc, List<Record> recordList, Status status) {
    
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
              listeningTabContentBloc.loadingMore(index);

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
                      onTap: () => RouteGenerator.navigateToListeningStory(recordList[index].slug),
                    )
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  if (index == recordList.length - 1 &&
                      status == Status.LOADINGMORE)
                    CupertinoActivityIndicator(),
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