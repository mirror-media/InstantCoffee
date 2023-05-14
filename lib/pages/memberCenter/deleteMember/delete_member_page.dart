import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/deleteMember/cubit.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/delete_member_widget.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/prohibit_deleting_widget.dart';

class DeleteMemberPage extends StatelessWidget {
  final String israfelId;
  final SubscriptionType subscriptionType;
  const DeleteMemberPage({
    required this.israfelId,
    required this.subscriptionType,
  });

  bool _isPremiumOrVip() {
    return subscriptionType == SubscriptionType.subscribe_group ||
        subscriptionType == SubscriptionType.subscribe_monthly ||
        subscriptionType == SubscriptionType.subscribe_yearly;
  }

  @override
  Widget build(BuildContext context) {
    if (_isPremiumOrVip()) {
      return ProhibitDeletingWidget();
    }

    return BlocProvider(
      create: (BuildContext context) => DeleteMemberCubit(),
      child: DeleteMemberWidget(israfelId: israfelId),
    );
  }
}
