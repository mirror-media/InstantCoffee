import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/storyPage.dart';
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/recordService.dart';
import 'package:readr_app/models/section.dart';

class TabContent extends StatefulWidget {
  final Section section;
  final ScrollController scrollController;
  TabContent({
    @required this.section,
    @required this.scrollController,
  });

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  String _endpoint = latestAPI;
  String _loadmoreUrl = '';
  int _page = 1;
  // tab widget list
  RecordList _records;

  @override
  void initState() {
    widget.scrollController.addListener(_loadingMore);
    _switch(widget.section.key, widget.section.type);
    super.initState();
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

    setState(() {
      _setRecords();
    });
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
      setState(() {
        _records.addAll(latests);
      });
    }
  }

  _loadingMore() {
    if (widget.scrollController.position.pixels ==
        widget.scrollController.position.maxScrollExtent) {
      if (_loadmoreUrl != '') {
        _endpoint = apiBase + _loadmoreUrl;
        _setRecords();
      }
    }
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
                return _buildTheFirstItem(context, _records[index]);
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
