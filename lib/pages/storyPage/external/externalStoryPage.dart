import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/externalStory/cubit.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/pages/storyPage/external/externalStoryWidget.dart';
import 'package:readr_app/services/externalStoryService.dart';
import 'package:share/share.dart';

class ExternalStoryPage extends StatelessWidget {
  final String slug;
  final bool isPremiumMode;
  const ExternalStoryPage(
      {Key? key, required this.slug, required this.isPremiumMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Share.share(Environment().config.mirrorMediaDomain+'/external/$slug');
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (BuildContext context) => ExternalStoryCubit(externalStoryRepos: ExternalStoryService()),
        child: ExternalStoryWidget(slug: slug, isPremiumMode: isPremiumMode),
      ),
    );
  }
}