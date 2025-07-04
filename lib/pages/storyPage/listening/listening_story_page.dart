import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/listening/cubit.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/storyPage/listening/listening_widget.dart';

class ListeningStoryPage extends StatelessWidget {
  final String slug;
  ListeningStoryPage({Key? key, required this.slug}) : super(key: key);

  final GlobalKey _shareButtonKey = GlobalKey();

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
            key: _shareButtonKey,
            icon: const Icon(Icons.share),
            tooltip: 'share',
            onPressed: () =>
                listeningStoryCubit.shareStory(shareButtonKey: _shareButtonKey),
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
