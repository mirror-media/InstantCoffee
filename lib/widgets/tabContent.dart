import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:readr_app/blocs/tabContentBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/sectionAd.dart';
import 'package:readr_app/pages/storyPage.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/widgets/editorChoiceCarousel.dart';
import 'package:readr_app/widgets/errorStatelessWidget.dart';

class TabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  final bool needCarousel;
  TabContent({
    @required this.section,
    @required this.scrollController,
    this.needCarousel = false,
  });

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  SectionAd _sectionAd;
  TabContentBloc _tabContentBloc;

  @override
  void initState() {
    _setAds();
    _tabContentBloc = TabContentBloc(
        widget.section.key, widget.section.type, widget.needCarousel);

    widget.scrollController.addListener(_loadingMore);
    super.initState();
  }

  _setAds() {
    _sectionAd = widget.section.sectionAd;
  }

  _loadingMore() {
    _tabContentBloc.loadingMore(widget.scrollController);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_loadingMore);
    _tabContentBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _tabContentBloc.refreshTheList(
            widget.section.key, widget.section.type, widget.needCarousel);
      },
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<ApiResponse<TabContentState>>(
              stream: _tabContentBloc.recordListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  TabContentState tabContentState = snapshot.data.data;

                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());
                      break;

                    case Status.LOADINGMORE:
                    case Status.COMPLETED:
                      RecordList recordList = tabContentState == null
                          ? _tabContentBloc.records
                          : tabContentState.recordList;
                      RecordList editorChoiceList = tabContentState == null
                          ? null
                          : tabContentState.editorChoiceList;

                      return _buildTheRecordList(context, recordList,
                          editorChoiceList, snapshot.data.status);
                      break;

                    case Status.ERROR:
                      return ErrorStatelessWidget(
                        errorMessage: snapshot.data.message,
                        onRetryPressed: () => _tabContentBloc.fetchRecordList(),
                      );
                      break;
                  }
                }
                return Container();
              },
            ),
          ),
          Container(
            height: 58,
            child: Center(
              child: AdmobBanner(
                adUnitId: _sectionAd.stUnitId,
                adSize: AdmobBannerSize.BANNER,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTheRecordList(BuildContext context, RecordList recordList,
      RecordList editorChoiceList, Status status) {
    return ListView(
      controller: widget.scrollController,
      children: [
        if (widget.needCarousel) ...[
          EditorChoiceCarousel(
            editorChoiceList: editorChoiceList,
          ),
          SizedBox(height: 16.0,),
          AdmobBanner(
            adUnitId: _sectionAd.aT1UnitId,
            adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
          ),
          SizedBox(height: 16.0,),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: _buildTagText(),
          ),
        ],
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recordList.length,
            itemBuilder: (context, index) {
              if (index == 0 && !widget.needCarousel) {
                return _buildTheFirstItem(context, recordList[index]);
              }

              return Column(
                children: [
                  if((index == 1 && !widget.needCarousel))
                    AdmobBanner(
                      adUnitId: _sectionAd.aT1UnitId,
                      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                  _buildListItem(context, recordList[index]),
                  if(index == 4 && widget.needCarousel) 
                    AdmobBanner(
                      adUnitId: _sectionAd.aT2UnitId,
                      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                  if(index == 5 && !widget.needCarousel) 
                    AdmobBanner(
                      adUnitId: _sectionAd.aT2UnitId,
                      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                    
                  if(index == 9 && widget.needCarousel) 
                    AdmobBanner(
                      adUnitId: _sectionAd.aT3UnitId,
                      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                  if(index == 10 && !widget.needCarousel) 
                    AdmobBanner(
                      adUnitId: _sectionAd.aT3UnitId,
                      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                  // if((((index + 1) % 5 == 0 && widget.needCarousel) || (index % 5 == 0 && !widget.needCarousel)) && index < 11) 
                  //   AdmobBanner(
                  //     adUnitId: BannerAd.testAdUnitId,
                  //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  //   ),
                  if (index == recordList.length - 1 &&
                      status == Status.LOADINGMORE)
                    CupertinoActivityIndicator(),
                ],
              );
            }),
      ],
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage(slug: record.slug)));
      },
    );
  }

  Widget _buildListItem(BuildContext context, Record record) {
    var width = MediaQuery.of(context).size.width;
    double imageSize = 25 * (width - 32) / 100;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    record.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                CachedNetworkImage(
                  height: imageSize,
                  width: imageSize,
                  imageUrl: record.photoUrl,
                  placeholder: (context, url) => Container(
                    height: imageSize,
                    width: imageSize,
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: imageSize,
                    width: imageSize,
                    color: Colors.grey,
                    child: Icon(Icons.error),
                  ),
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(height: 8,),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage(slug: record.slug)));
      },
    );
  }
}
