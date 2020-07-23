import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:readr_app/helpers/boolBloc.dart';
import 'package:readr_app/models/editorChoiceService.dart';
import 'package:readr_app/storyPage.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/recordService.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/widgets/editorChoiceCarousel.dart';

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
  String _endpoint = latestAPI;
  BoolBloc _loadingBloc = BoolBloc();
  String _loadmoreUrl = '';
  int _page = 1;

  RecordList _editorChoiceList;
  // tab widget list
  RecordList _records;

  @override
  void initState() {
    if(widget.needCarousel) {
      _setEditorChoiceList();
    }

    _loadingBloc.setFlag(false);
    widget.scrollController.addListener(_loadingMore);
    _switch(widget.section.key, widget.section.type);
    super.initState();
  }

  void _setEditorChoiceList() async {
    String jsonString = await EditorChoiceService().loadData();
    final jsonObject = json.decode(jsonString);
    if(mounted)
    {
      setState(() {
        _editorChoiceList = RecordList.fromJson(jsonObject["choices"]);
      });
    }
  }

  _switch(String id, String type) {
    _page = 1;
    if (type == 'section') {
      _endpoint = listingBase + '&where={"sections":{"\$in":["' + id + '"]}}';
    } else if (id == 'latest') {
      _endpoint = latestAPI;
    } else if (id == 'popular') {
      _endpoint = popularListAPI;
    } else if (id == 'personal') {
      _endpoint = listingBaseSearchByPersonAndFoodSection;
    }

    _setRecords();
  }

  Future<void> _setRecords() async {
    RecordService recordService = RecordService();
    RecordList latests = await recordService.loadLatests(_endpoint);
    _loadmoreUrl = recordService.getNext();
    if (_page == 1 && _records != null) {
      _records.clear();
    }
    _page++;

    if (_records == null) {
      _records = RecordList();
    }

    if (mounted) {
      _records.addAll(latests);

      if (_loadingBloc.flag) {
        _loadingBloc.change(false);
      }
      setState(() {});
    }
  }

  _loadingMore() {
    if (widget.scrollController.position.pixels ==
        widget.scrollController.position.maxScrollExtent) {
      if (_loadmoreUrl != '' && !_loadingBloc.flag) {
        //print(_loadmoreUrl);
        _loadingBloc.change(true);
        _endpoint = apiBase + _loadmoreUrl;
        _setRecords();
      }
    }
  }

  @override
  void dispose() {
    _loadingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _records == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: widget.scrollController,
            itemCount: _records.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                if (widget.needCarousel) {
                  return EditorChoiceCarousel(editorChoiceList: _editorChoiceList,);
                }
                return _buildTheFirstItem(context, _records[index]);
              }

              if (index == _records.length - 1) {
                return Column(
                  children: [
                    _buildListItem(context, _records[index]),
                    StreamBuilder<bool>(
                      initialData: _loadingBloc.flag,
                      stream: _loadingBloc.controller.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                );
              }
              return _buildListItem(context, _records[index]);
            });
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
    var width = MediaQuery.of(context).size.width;

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
