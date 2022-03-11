import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/news/bloc.dart';
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
    _fetchPublishedStoryBySlug(context.read<StoryBloc>().currentStorySlug, false);
  }

  _fetchPublishedStoryBySlug(String storySlug, bool isMemberCheck) {
    context.read<StoryBloc>().add(
      FetchPublishedStoryBySlug(storySlug, isMemberCheck)
    );
  }

  _delayNavigatorPop() async{
    await Future.delayed(Duration(milliseconds: 0));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryBloc, StoryState>(
      builder: (BuildContext context, StoryState state) {
        switch (state.status) {
          case StoryStatus.error:
            final error = state.errorMessages;
            print('StoryError: ${error.message}');
            _delayNavigatorPop();
            return Container();
          case StoryStatus.loaded:
            StoryRes storyRes = state.storyRes!;

            if(storyRes.story.apiDatas.length == 0) {
              _delayNavigatorPop();
            }

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
          default:
            // state is Init, Loading
            return _loadingWidget();
        }
      }
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }
}