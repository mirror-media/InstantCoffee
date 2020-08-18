import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/listeningTabContentBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/storyPage.dart';
import 'package:readr_app/widgets/errorStatelessWidget.dart';

class ListeningTabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  ListeningTabContent({
    @required this.section,
    @required this.scrollController,
  });

  @override
  _ListeningTabContentState createState() => _ListeningTabContentState();
}

class _ListeningTabContentState extends State<ListeningTabContent> {
  ListeningTabContentBloc _listeningTabContentBloc;

  @override
  void initState() {
    _listeningTabContentBloc = ListeningTabContentBloc();

    widget.scrollController.addListener(_loadingMore);

    super.initState();
  }

  _loadingMore() {
    _listeningTabContentBloc.loadingMore(widget.scrollController);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_loadingMore);
    _listeningTabContentBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _listeningTabContentBloc.refreshTheList();
      },
      child: StreamBuilder<ApiResponse<RecordList>>(
        stream: _listeningTabContentBloc.listeningTabContentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.LOADINGMORE:
              case Status.COMPLETED:
                RecordList recordList = snapshot.data.data == null
                    ? _listeningTabContentBloc.records
                    : snapshot.data.data;

                return _buildTheRecordList(
                    context, recordList, snapshot.data.status);
                break;

              case Status.ERROR:
                return ErrorStatelessWidget(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () =>
                      _listeningTabContentBloc.fetchRecordList(),
                );
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildTheRecordList(
      BuildContext context, RecordList recordList, Status status) {
    return ListView(
      controller: widget.scrollController,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recordList.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildTheFirstItem(context, recordList[index]);
              }

              return Column(
                children: [
                  _buildListItem(context, recordList[index]),
                  if (index == recordList.length - 1 &&
                      status == Status.LOADINGMORE)
                    CupertinoActivityIndicator(),
                ],
              );
            }),
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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage(
                      slug: record.slug,
                      isListeningWidget: true,
                    )));
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
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoryPage(
                      slug: record.slug,
                      isListeningWidget: true,
                    )));
      },
    );
  }
}
