import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/story/bloc.dart';
import 'package:readr_app/blocs/story/events.dart';
import 'package:readr_app/blocs/story/states.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/pages/termsOfService/termsOfServiceWidget.dart';

class MMTermsOfServiceWidget extends StatefulWidget {
  @override
  _MMTermsOfServiceWidgetState createState() => _MMTermsOfServiceWidgetState();
}

class _MMTermsOfServiceWidgetState extends State<MMTermsOfServiceWidget> {
  @override
  void initState() {
    super.initState();
    _fetchPublishedStoryBySlug('service-rule');
  }

  _fetchPublishedStoryBySlug(String storySlug) {
    context.read<StoryBloc>().add(
      FetchPublishedStoryBySlug(storySlug)
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryBloc, StoryState>(
      builder: (BuildContext context, StoryState state) {
        if (state is StoryError) {
          final error = state.error;
          print('StoryError: ${error.message}');
          return Container();
        }

        if (state is StoryLoaded) {
          StoryRes storyRes = state.storyRes;
          // change font size
          for(int i=0; i<storyRes.story.apiDatas.length; i++) {
            if(storyRes.story.apiDatas[i].type == 'header-two') {
              storyRes.story.apiDatas[i].type  = 'unstyled';
            }
          }

          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: TermsOfServiceWidget(story: storyRes.story,),
          );
        }

        // state is Init, Loading
        return _loadingWidget();
      }
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }
}