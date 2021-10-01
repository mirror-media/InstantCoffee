import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/subscriptionSelectWidget.dart';
import 'package:readr_app/services/subscriptionSelectService.dart';

class SubscriptionSelectPage extends StatelessWidget {
  final String titleText;
  SubscriptionSelectPage(this.titleText);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: BlocProvider(
        create: (context) => SubscriptionSelectBloc(subscriptionSelectRepos: SubscriptionSelectServices()),
        child: SubscriptionSelectWidget(),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        titleText,
      ),
      backgroundColor: appColor,
    );
  }
}