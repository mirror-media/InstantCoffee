import 'package:flutter/material.dart';
import '../helpers/Constants.dart';
import '../models/Record.dart';
import '../models/SectionList.dart';
import '../models/LatestList.dart';
import '../models/LatestService.dart';
import '../StoryPage.dart';

class ListingWidget extends StatefulWidget{
  final String endpoint;
  const ListingWidget ({ key, this.endpoint }) : super(key: key);

  @override 
  _ListingWidget createState () {
    return _ListingWidget();
  }
}

class _ListingWidget extends State<ListingWidget> {
  String endpoint;
  ScrollController _controller;
  String loadmoreUrl = '';
  LatestList _records = new LatestList();
  LatestList _filteredRecords = new LatestList();
  SectionList sectionItems = new SectionList();
  int page = 1;
  String _searchText = "";
  Widget _appBarTitle = new Text(appTitle);

  @override 
  void initState() {
    super.initState();
    _controller = ScrollController();
    print("endpoint from widget: " + widget.endpoint);

    _getLatests();
  }

  void _getLatests() async {
    LatestService latestService = new LatestService(); 
    LatestList latests = await latestService.loadLatests(widget.endpoint);
    this.loadmoreUrl = latestService.getNext();
    print("loadmore: " + this.loadmoreUrl);
    if (this.page == 1) {
      this._records.records = [];
      this._filteredRecords.records = [];
    }
    this.page++;

    setState(() {
      Record record = new Record();
      for (int i = 0; i < latests.records.length; i++) {
        record = latests.records[i];
        this._filteredRecords.records.add(record);
        this._records.records.add(record);
      }
    });
  }

  Widget build(BuildContext context) {
    _getLatests();
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (!(_searchText.isEmpty)) {
    _filteredRecords.records = new List();
      for (int i = 0; i < _records.records.length; i++) {
        if (_records.records[i].title.toLowerCase().contains(_searchText.toLowerCase())
            || _records.records[i].slug.toLowerCase().contains(_searchText.toLowerCase())) {
          _filteredRecords.records.add(_records.records[i]);
        }
      }
    } 

    List<Widget> storyList = new List();
    for (int i = 0; i < _filteredRecords.records.length; i++) {
      storyList.add(_buildListItem(context,_filteredRecords.records[i]));
    }
    return ListView(
      controller: _controller,
      padding: const EdgeInsets.only(top: 5.0),
      children: storyList,
    );
  }

  _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent ) {
      if (this.loadmoreUrl != '') {
        this.endpoint = apiBase + this.loadmoreUrl;
        _getLatests();
      }
    }
    return true;
  }

  Widget _buildListItem(BuildContext context, Record record) {
    return Card(
      key: ValueKey(record.title),
      //elevation: 8.0,
      color: Colors.white,
      //margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
      child: Container(
        //decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, .4)),
        child: ListTile(
          //contentPadding:
          //EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          title: Text(
            record.title,
            style: TextStyle(color: Colors.black, height: 1.8, fontSize: 19),
          ),
          trailing: Container(
              padding: EdgeInsets.only(right: 5.0),
              child: Hero(
                  tag: record.title,
                  child: Image(
                    image: NetworkImage(record.photo),
                    fit: BoxFit.fitWidth,
                    colorBlendMode: BlendMode.darken,
                  )
              ),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => new StoryPage(slug: record.slug)));
          },
        ),
      ),
    );
  }

}