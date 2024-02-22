import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/listening/cubit.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/pages/storyPage/listening/listening_widget.dart';
import 'package:share_plus/share_plus.dart';

class ListeningStoryPage extends StatelessWidget {
  final String slug;
  const ListeningStoryPage({Key? key, required this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListeningStoryCubit listeningStoryCubit =
        ListeningStoryCubit(storySlug: slug);

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
            icon: const Icon(Icons.share),
            tooltip: 'share',
            onPressed: () {
              String url = listeningStoryCubit.getShareUrlFromSlug();
              Share.share(url);
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => listeningStoryCubit,
        child: const ListeningWidget(),
      ),
    );
  }
}
