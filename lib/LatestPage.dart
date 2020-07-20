import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/NotificationSettingsPage.dart';

import 'helpers/Constants.dart';
import 'models/Record.dart';
import 'models/Section.dart';
import 'models/SectionList.dart';
import 'models/SectionService.dart';
import 'models/LatestList.dart';
import 'models/LatestService.dart';
import 'StoryPage.dart';

class LatestPage extends StatefulWidget {
  @override
  _LatestPageState createState() {
    return _LatestPageState();
  }
}

class _LatestPageState extends State<LatestPage> {
  final LocalStorage storage = new LocalStorage('setting');
  final TextEditingController _filter = new TextEditingController();

  LatestList _records = new LatestList();
  LatestList _filteredRecords = new LatestList();
  SectionList sectionItems = new SectionList();
  ScrollController _controller;

  String _searchText = "";
  String endpoint = latestAPI;
  String loadmoreUrl = '';
  int page = 1;
  String sectionJson;

  Icon _searchIcon = new Icon(Icons.search);

  Widget _appBarTitle = new Text(appTitle);

  @override
  void initState() {
    _records.records = new List();
    _filteredRecords.records = new List();
    //sectionItems.sections = new List();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _getSections();

    //else {
    //  _getSections();
    //}

    _getLatests();
    super.initState();
  }

  void _getSections() async {
    sectionItems = new SectionList();
    SectionList allSections = new SectionList();
    allSections = await SectionService().loadSections();
    setState(() {
      for (Section section in allSections) {
        this.sectionItems.add(section);
      }
    });
  }

  void _getLatests() async {
    LatestService latestService = new LatestService();
    LatestList latests = await latestService.loadLatests(this.endpoint);
    this.loadmoreUrl = latestService.getNext();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: appColor,
      body: Column(
        children: <Widget>[
          _buildNavigation(context),
          Expanded(
            child: _buildList(context),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildNavigation(BuildContext context) {
    List<Widget> items = new List();
    if (sectionItems != null) {
      setState(() {
        sectionJson = storage.getItem("sections");
        if (sectionJson != null) {
          sectionItems = SectionList.fromJson(json.decode(sectionJson));
        }
        sectionItems.sort((a, b) => a.order.compareTo(b.order));
        for (Section section in sectionItems) {
          items.add(_buildNavigationItem(context, section));
        }
      });
      return new Container(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: items,
          ));
    } else {
      return Container();
    }
  }

  Widget _buildNavigationItem(BuildContext context, Section section) {
    return new RaisedButton(
        onPressed: () => _switch(section.key, section.type),
        child: Text(
          section.title,
        ));
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.1,
      leading: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationSettingsPage(),
            fullscreenDialog: true,
          ),
        ),
      ),
      backgroundColor: appColor,
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => {},
        ),
      ],
    );
  }

  Widget _buildLeading(BuildContext context, Record leading) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new StoryPage(slug: leading.slug)));
      },
      child: Card(
          child: Column(
        children: [
          Image.network(leading.photo),
          Text(leading.title),
        ],
      )),
    );
  }

  Widget _buildList(BuildContext context) {
    if (!(_searchText.isEmpty)) {
      _filteredRecords.records = new List();
      for (int i = 0; i < _records.records.length; i++) {
        if (_records.records[i].title
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            _records.records[i].slug
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          _filteredRecords.records.add(_records.records[i]);
        }
      }
    }

    List<Widget> storyList = new List();
    for (int i = 0; i < _filteredRecords.records.length; i++) {
      if (_searchText.isEmpty && i == 0) {
        storyList.add(_buildLeading(context, _filteredRecords.records[i]));
      } else {
        storyList.add(_buildListItem(context, _filteredRecords.records[i]));
      }
    }
    return ListView(
      controller: _controller,
      padding: const EdgeInsets.only(top: 5.0),
      children: storyList,
    );
  }

  _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
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
                )),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new StoryPage(slug: record.slug)));
          },
        ),
      ),
    );
  }

  _LatestPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _resetRecords();
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  _switch(String id, String type) {
    this.page = 1;
    if (type == 'section') {
      this.endpoint =
          listingBase + '&where={%22sections%22:{%22\$in%22:["' + id + '"]}}';
    } else if (id == 'latest') {
      this.endpoint = latestAPI;
    } else if (id == 'popular') {
      this.endpoint = popularListAPI;
    } else if (id == 'personal') {
      this.endpoint = listingBaseSearchByPersonAndFoodSection;
    }

    setState(() {
      _getLatests();
    });
    _controller.jumpTo(1);
  }

  void _resetRecords() {
    this._filteredRecords.records = new List();
    for (Record record in _records.records) {
      this._filteredRecords.records.add(record);
    }
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: new TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.white),
            fillColor: Colors.white,
            hintText: 'Search by title',
            hintStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(appTitle);
        _filter.clear();
      }
    });
  }
}
