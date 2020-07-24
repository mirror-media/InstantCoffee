import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/tabContentBloc.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/constants.dart';

import 'package:readr_app/models/editorChoiceService.dart';
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
  TabContentBloc _tabContentBloc;
  RecordList _editorChoiceList;

  @override
  void initState() {
    _tabContentBloc = TabContentBloc(widget.section.key, widget.section.type);

    widget.scrollController.addListener(_loadingMore);

    if (widget.needCarousel) {
      _setEditorChoiceList();
    }
    super.initState();
  }

  _loadingMore() {
    _tabContentBloc.loadingMore(widget.scrollController);
  }

  void _setEditorChoiceList() async {
    String jsonString = await EditorChoiceService().loadData();
    final jsonObject = json.decode(jsonString);
    if (mounted) {
      setState(() {
        _editorChoiceList = RecordList.fromJson(jsonObject["choices"]);
      });
    }
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
        _tabContentBloc.refreshTheList(widget.section.key, widget.section.type);
      },
      child: StreamBuilder<ApiResponse<RecordList>>(
        stream: _tabContentBloc.recordListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.LOADINGMORE:
              case Status.COMPLETED:
                RecordList recordList = snapshot.data.data == null
                    ? _tabContentBloc.records
                    : snapshot.data.data;
                return _buildTheRecordList(
                    context, recordList, snapshot.data.status);
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
    );
  }

  Widget _buildTheRecordList(
      BuildContext context, RecordList recordList, Status status) {
    return ListView(
      controller: widget.scrollController,
      children: [
        if(widget.needCarousel)
        ...[
          EditorChoiceCarousel(
            editorChoiceList: _editorChoiceList,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                _buildListItem(context, recordList[index]),
                if (index == recordList.length - 1 && status == Status.LOADINGMORE)
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
            imageUrl: record.photo,
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
                builder: (context) => new StoryPage(slug: record.slug)));
      },
    );
  }

  Widget _buildListItem(BuildContext context, Record record) {
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
                  height: 90,
                  width: 90,
                  imageUrl: record.photo,
                  placeholder: (context, url) => Container(
                    height: 90,
                    width: 90,
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 90,
                    width: 90,
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
                builder: (context) => new StoryPage(slug: record.slug)));
      },
    );
  }
}
