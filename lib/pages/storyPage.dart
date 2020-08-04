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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'share',
            onPressed: (){},
          )
        ],
      ),
      body: StoryWidget(slug: slug),
    );
  }
}
