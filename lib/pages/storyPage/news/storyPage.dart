import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/news/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/storyPage/news/memberStoryWidget.dart';
import 'package:readr_app/services/storyService.dart';
import 'package:readr_app/pages/storyPage/news/storyWidget.dart';
import 'package:share/share.dart';

class StoryPage extends StatelessWidget {
  final String slug;
  final bool isMemberCheck;
  final bool isMemberContent;
  const StoryPage(
      {Key? key, required this.slug, required this.isMemberCheck, this.isMemberContent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryBloc _storyBloc = StoryBloc(
      storySlug: slug,
      storyRepos: StoryService()
    );

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
              String url = _storyBloc.getShareUrlFromSlug();
              Share.share(url);
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => _storyBloc,
        child: isMemberContent 
                ? MemberStoryWidget(slug: slug, isMemberCheck: isMemberCheck)
                : StoryWidget(isMemberCheck: isMemberCheck),
      ),
    );
  }
}
