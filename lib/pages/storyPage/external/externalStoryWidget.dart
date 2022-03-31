import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/externalStory/cubit.dart';
import 'package:readr_app/blocs/externalStory/states.dart';
import 'package:readr_app/models/externalStory.dart';
import 'package:readr_app/pages/storyPage/external/defaultBody.dart';

class ExternalStoryWidget extends StatefulWidget {
  final String slug;
  const ExternalStoryWidget(
      {Key? key, required this.slug})
      : super(key: key);

  @override
  _ExternalStoryWidgetState createState() => _ExternalStoryWidgetState();
}

class _ExternalStoryWidgetState extends State<ExternalStoryWidget> {
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
    return BlocBuilder<ExternalStoryCubit, ExternalStoryState>(
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
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }
}