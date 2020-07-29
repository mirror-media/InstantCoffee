import "package:flutter/material.dart";
import '../helpers/constants.dart';
import '../widgets/storyWidget.dart';

class StoryPage extends StatelessWidget {
  final String slug;
  const StoryPage({Key key, this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => doSearch(),
          )
        ],
      ),
      body: StoryWidget(slug: this.slug),
    );
  }

  doSearch() {
    return null;
  }
}
