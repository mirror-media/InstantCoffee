import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/listening/cubit.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/storyPage/listening/listeningWidget.dart';
import 'package:share/share.dart';

class ListeningStoryPage extends StatelessWidget {
  final String slug;
  const ListeningStoryPage(
      {Key? key, required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListeningStoryCubit _listeningStoryCubit= ListeningStoryCubit(
      storySlug: slug
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
              String url = _listeningStoryCubit.getShareUrlFromSlug();
              Share.share(url);
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => _listeningStoryCubit,
        child: ListeningWidget(),
      ),
    );
  }
}