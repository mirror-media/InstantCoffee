import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/storyPage/news/bloc.dart';
import 'package:readr_app/models/story_res.dart';
import 'package:readr_app/pages/storyPage/news/premium_story_widget.dart';
import 'package:readr_app/pages/storyPage/news/story_widget.dart';
import 'package:readr_app/services/comscore_service.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';

import '../../../data/enum/story_status.dart';

class BuildStoryPage extends StatefulWidget {
  final bool isMemberCheck;

  const BuildStoryPage({key, required this.isMemberCheck}) : super(key: key);

  @override
  _BuildStoryPageState createState() => _BuildStoryPageState();
}

class _BuildStoryPageState extends State<BuildStoryPage> with Logger {
  late StoryBloc _storyBloc;

  _fetchPublishedStoryBySlug(String storySlug, bool isMemberCheck) {
    _storyBloc.add(FetchPublishedStoryBySlug(storySlug, isMemberCheck));
  }

  @override
  void initState() {
    _storyBloc = context.read<StoryBloc>();
    _fetchPublishedStoryBySlug(
        _storyBloc.currentStorySlug, widget.isMemberCheck);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryBloc, StoryState>(
        builder: (BuildContext context, StoryState state) {
      switch (state.status) {
        case StoryStatus.error:
          final error = state.errorMessages;
          debugLog('StoryError: ${error.message}');
          return Container();
        case StoryStatus.loaded:
          StoryRes storyRes = state.storyRes!;
          bool isPremiumArticle = storyRes.story.isMember;

          // Track with Comscore
          ComscoreService.instance.trackStoryView(
            storyTitle: storyRes.story.title,
            storySlug: storyRes.story.slug,
            categoryName: storyRes.story.sections.isNotEmpty
                ? storyRes.story.sections.first.title
                : null,
            authorName: storyRes.story.writers.isNotEmpty
                ? storyRes.story.writers.first.name
                : null,
            publishedDate: DateTime.tryParse(storyRes.story.publishedDate),
          );

          // 檢查 isFreePremium 狀態
          bool isFreePremiumEnabled = false;
          try {
            final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
            isFreePremiumEnabled = remoteConfigHelper.isFreePremium;
          } catch (e) {
            // RemoteConfig 未初始化時跳過
          }

          if (isFreePremiumEnabled) {
            if (isPremiumArticle) {
              return PremiumStoryWidget(
                isLogin: storyRes.isMember,
                story: storyRes.story,
              );
            } else {
              return StoryWidget(
                story: storyRes.story,
              );
            }
          }

          bool isActualPremiumMember =
              context.read<MemberBloc>().state.shouldShowPremiumUI;
          if (isActualPremiumMember) {
            return PremiumStoryWidget(
              isLogin: storyRes.isMember,
              story: storyRes.story,
            );
          }
          return StoryWidget(
            story: storyRes.story,
          );
        default:
          // state is Init, Loading
          return _loadingWidget();
      }
    });
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
