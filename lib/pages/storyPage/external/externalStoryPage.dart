import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/externalStory/cubit.dart';
import 'package:readr_app/blocs/externalStory/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/externalStory.dart';
import 'package:readr_app/pages/storyPage/external/defaultBody.dart';
import 'package:readr_app/services/externalStoryService.dart';
import 'package:share/share.dart';

class ExternalStoryPage extends StatefulWidget {
  final String slug;
  const ExternalStoryPage(
      {Key? key, required this.slug})
      : super(key: key);

  @override
  State<ExternalStoryPage> createState() => _ExternalStoryPageState();
}

class _ExternalStoryPageState extends State<ExternalStoryPage> {
  _fetchPublishedStoryBySlug(String storySlug) {
    context.read<ExternalStoryCubit>().fetchExternalStory(storySlug);
  }

  @override
  void initState() {
    _fetchPublishedStoryBySlug(widget.slug);
    super.initState();
  }

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
              Share.share(Environment().config.mirrorMediaDomain+'/external/${widget.slug}');
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (BuildContext context) => ExternalStoryCubit(externalStoryRepos: ExternalStoryService()),
        child: BlocBuilder<ExternalStoryCubit, ExternalStoryState>(
          builder: (context, state) {
            if(state.status == ExternalStoryStatus.loaded) {
              ExternalStory externalStory = state.externalStory!;
              
              return DefaultBody(externalStory: externalStory);
            } else if(state.status == ExternalStoryStatus.error) {
              print('ExternalStoryWidget error: ${state.errorMessages}');
              return Container();
            }

            // initial or loading
            return _loadingWidget();
          }
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }
}