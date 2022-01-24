import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/storyPage/news/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/termsOfService/mMTermsOfServiceWidget.dart';
import 'package:readr_app/services/storyService.dart';

class MMTermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => StoryBloc(
          storySlug: 'service-rule',
          storyRepos: StoryService()
        ),
        child: MMTermsOfServiceWidget(),
      ),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        '鏡週刊',
      ),
      backgroundColor: appColor,
    );
  }
}