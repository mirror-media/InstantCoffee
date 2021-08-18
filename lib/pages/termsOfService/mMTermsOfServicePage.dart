import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/pages/termsOfService/termsOfServiceWidget.dart';

class MMTermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: TermsOfServiceWidget(story: Story(),),
    );
  }

  Widget _buildBar(BuildContext context) {
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