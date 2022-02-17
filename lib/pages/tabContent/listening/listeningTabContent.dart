import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/blocs/listeningTabContentBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/tabContent/shared/listItem.dart';
import 'package:readr_app/widgets/errorStatelessWidget.dart';
import 'package:readr_app/widgets/mMAdBanner.dart';
import 'package:readr_app/widgets/newsMarquee/newsMarqueePersistentHeaderDelegate.dart';

class ListeningTabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  ListeningTabContent({
    required this.section,
    required this.scrollController,
  });

  @override
  _ListeningTabContentState createState() => _ListeningTabContentState();
}

class _ListeningTabContentState extends State<ListeningTabContent> {
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
      child: Column(
        children: [
          Expanded(
            child: _buildListeningTabContentBody(),
          ),
          if(isListeningTabContentAdsActivated && _listeningTabContentBloc.sectionAd.stUnitId != '')
            MMAdBanner(
              adUnitId: _listeningTabContentBloc.sectionAd.stUnitId,
              adSize: AdSize.banner,
            ),
        ],
      ),
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
                return _buildTheFirstItem(context, recordList[index]);
              }

              return Column(
                children: [
                  if(isListeningTabContentAdsActivated && index == noCarouselAT1AdIndex)
                    MMAdBanner(
                      adUnitId: _listeningTabContentBloc.sectionAd.aT1UnitId,
                      adSize: AdSize.mediumRectangle,
                    ),
                  ListItem(
                    record: recordList[index],
                    onTap: () => RouteGenerator.navigateToListeningStory(
                        recordList[index].slug),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  if(isListeningTabContentAdsActivated && index == noCarouselAT2AdIndex)
                    MMAdBanner(
                      adUnitId: _listeningTabContentBloc.sectionAd.aT2UnitId,
                      adSize: AdSize.mediumRectangle,
                    ),
                  if(isListeningTabContentAdsActivated && index == noCarouselAT3AdIndex)
                    MMAdBanner(
                      adUnitId: _listeningTabContentBloc.sectionAd.aT3UnitId,
                      adSize: AdSize.mediumRectangle,
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

  Widget _buildTheFirstItem(BuildContext context, Record record) {
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      child: Column(
        children: [
          CachedNetworkImage(
            height: width / 16 * 9,
            width: width,
            imageUrl: record.photoUrl,
            placeholder: (context, url) => Container(
              height: width / 16 * 9,
              width: width,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              height: width / 16 * 9,
              width: width,
              color: Colors.grey,
              child: Icon(Icons.error),
            ),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Text(
              record.title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
      onTap: () => RouteGenerator.navigateToListeningStory(record.slug),
    );
  }
}
