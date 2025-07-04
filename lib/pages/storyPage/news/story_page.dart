import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/storyPage/news/bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/storyPage/news/build_story_page.dart';
import 'package:readr_app/services/story_service.dart';

class StoryPage extends StatelessWidget {
  final String slug;
  final bool isMemberCheck;
  StoryPage({Key? key, required this.slug, required this.isMemberCheck})
      : super(key: key);

  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final StoryBloc storyBloc =
        StoryBloc(storySlug: slug, storyRepos: StoryService());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              key: _shareButtonKey,
              icon: const Icon(Icons.share),
              tooltip: 'share',
              onPressed: () =>
                  storyBloc.shareStory(shareButtonKey: _shareButtonKey),
            )
          ],
        ),
        body: BlocConsumer<MemberBloc, MemberState>(
            listener: (BuildContext context, MemberState state) {
          if (state.status == MemberStatus.loaded) {
            storyBloc.add(FetchPublishedStoryBySlug(
                storyBloc.state.storySlug, isMemberCheck));
          }
        }, builder: (BuildContext context, MemberState state) {
          return BlocProvider(
              create: (context) => storyBloc,
              child: BuildStoryPage(isMemberCheck: isMemberCheck));
        }));
  }
}
