import 'package:flutter/material.dart';
import 'package:readr_app/blocs/slugBloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/storyPage/listening/listeningWidget.dart';
import 'package:share/share.dart';

class ListeningStroyPage extends StatelessWidget {
  final String slug;
  const ListeningStroyPage(
      {Key key, @required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SlugBloc _slugBloc = SlugBloc(slug);

    return Scaffold(
      backgroundColor: Colors.white,
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
            onPressed: () {
              String url = _slugBloc.getShareUrlFromSlug(true);
              Share.share(url);
            },
          )
        ],
      ),
      body: ListeningWidget(slugBloc: _slugBloc),
    );
  }
}