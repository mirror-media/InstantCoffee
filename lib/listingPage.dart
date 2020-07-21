import 'package:flutter/material.dart';
import 'helpers/constants.dart';
import 'models/sectionList.dart';
import 'widgets/listingWidget.dart';

class ListingPage extends StatefulWidget {
  @override
  _AuthorPageState createState() {
    return _AuthorPageState();
  }
}

class _AuthorPageState extends State<ListingPage> {
  SectionList sectionItems = new SectionList();
  String endpoint = latestAPI;
  String loadmoreUrl = '';
  int page = 1;

  Widget listing;
  Widget _appBarTitle = new Text(appTitle);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: appColor,
      body: ListingWidget(endpoint: this.endpoint),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.1,
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
}
