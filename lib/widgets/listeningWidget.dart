import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/listeningWidgetBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/models/listening.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/widgets/mMAdBanner.dart';
import 'package:readr_app/widgets/youtubeWidget.dart';

class ListeningWidget extends StatefulWidget {
  final String slug;
  const ListeningWidget({key, @required this.slug}) : super(key: key);

  @override
  _ListeningWidget createState() {
    return _ListeningWidget();
  }
}

class _ListeningWidget extends State<ListeningWidget> {
  ListeningWidgetBloc _listeningWidgetBloc;

  @override
  void initState() {
    _listeningWidgetBloc = ListeningWidgetBloc(widget.slug);
    super.initState();
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return StreamBuilder<ApiResponse<TabContentState>>(
      stream: _listeningWidgetBloc.listeningWidgetStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(child: CircularProgressIndicator());
              break;

            case Status.LOADINGMORE:
            case Status.COMPLETED:
              TabContentState tabContentState = snapshot.data.data;

              return Column(
                children: [
                  Expanded(
                    child: ListView(children: [
                      YoutubeWidget(
                        width: width,
                        youtubeId: tabContentState.listening.slug,
                      ),
                      SizedBox(height: 16.0),
                      if(isListeningWidgetAdsActivated)
                      ...[
                        MMAdBanner(
                          adUnitId: tabContentState.listening.storyAd.hDUnitId,
                          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                        ),
                        SizedBox(height: 16),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: _buildTitleAndDescription(tabContentState.listening),
                      ),
                      SizedBox(height: 16.0),
                      if(isListeningWidgetAdsActivated)
                      ...[
                        MMAdBanner(
                          adUnitId: tabContentState.listening.storyAd.aT1UnitId,
                          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                        ),
                        SizedBox(height: 16),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: _buildTheNewestVideos(width, tabContentState.recordList),
                      ),
                      if(isListeningWidgetAdsActivated)
                      ...[
                        MMAdBanner(
                          adUnitId: tabContentState.listening.storyAd.fTUnitId,
                          adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                        ),
                        SizedBox(height: 16),
                      ],
                    ]),
                  ),
                  if(isListeningWidgetAdsActivated)
                    MMAdBanner(
                      adUnitId: tabContentState.listening.storyAd.stUnitId,
                      adSize: AdmobBannerSize.BANNER,
                    ),
                ],
              );
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

  _buildTitleAndDescription(Listening listening) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Column(
      children: [
        Text(
          listening.title,
          style: TextStyle(
            fontSize: 28,
            color: appColor,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(
              dateTimeFormat.changeYoutubeStringToDisplayString(
                  listening.publishedAt, 'yyyy/MM/dd HH:mm:ss'),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          listening.description.split('-----')[0],
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  _buildTheNewestVideos(double width, RecordList recordList) {
    double imageWidth = width - 32;
    double imageHeight = width / 16 * 9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '最新影音',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appColor,
          ),
        ),
        SizedBox(height: 16,),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recordList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Column(
                  children: [
                    CachedNetworkImage(
                      height: imageHeight,
                      width: imageWidth,
                      imageUrl: recordList[index].photoUrl,
                      placeholder: (context, url) => Container(
                        height: imageHeight,
                        width: imageWidth,
                        color: Colors.grey,
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: imageHeight,
                        width: imageWidth,
                        color: Colors.grey,
                        child: Icon(Icons.error),
                      ),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      recordList[index].title,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                onTap: () {
                  _listeningWidgetBloc.fetchListening(recordList[index].slug);
                },
              );
            }),
      ],
    );
  }
}
