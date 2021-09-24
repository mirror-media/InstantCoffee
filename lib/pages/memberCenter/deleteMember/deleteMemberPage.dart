import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/deleteMember/cubit.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/deletMemberWidget.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/prohibitDeletingWidget.dart';

class DeleteMemberPage extends StatelessWidget {
  final String israfelId;
  final SubscritionType subscritionType;
  DeleteMemberPage({
    @required this.israfelId,
    @required this.subscritionType,
  });

  bool _isPremiumOrVip() {
    return subscritionType == SubscritionType.marketing ||
        subscritionType == SubscritionType.subscribe_monthly ||
        subscritionType == SubscritionType.subscribe_yearly;
  }

  @override
  Widget build(BuildContext context) {
    if(_isPremiumOrVip()) {
      return ProhibitDeletingWidget();
    }

    return BlocProvider(
      create: (BuildContext context) => DeleteMemberCubit(),
      child: DeleteMemberWidget(israfelId: israfelId),
    );
  }
}