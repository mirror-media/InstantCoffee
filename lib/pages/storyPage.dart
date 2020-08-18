import "package:flutter/material.dart";
import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/widgets/listingWidget.dart';
import 'package:readr_app/widgets/storyWidget.dart';

class StoryPage extends StatelessWidget {
  final String slug;
  final bool isListingWidget;
  const StoryPage({
    Key key, 
    @required this.slug, 
    this.isListingWidget = false
  }) : super(key: key);

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
            onPressed: () {},
          )
        ],
      ),
      body: isListingWidget ? ListingWidget(slug: slug) : StoryWidget(slug: slug),
    );
  }
}
