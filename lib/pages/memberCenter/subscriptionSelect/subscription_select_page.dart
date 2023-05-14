import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/bloc.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/subscription_select_widget.dart';
import 'package:readr_app/services/subscription_select_service.dart';

class SubscriptionSelectPage extends StatefulWidget {
  final String? storySlug;
  const SubscriptionSelectPage({this.storySlug});

  @override
  State<SubscriptionSelectPage> createState() => _SubscriptionSelectPageState();
}

class _SubscriptionSelectPageState extends State<SubscriptionSelectPage> {
  late SubscriptionSelectBloc _subscriptionSelectBloc;

  @override
  void initState() {
    _subscriptionSelectBloc = SubscriptionSelectBloc(
      subscriptionSelectRepos: SubscriptionSelectServices(),
      memberBloc: context.read<MemberBloc>(),
      storySlug: widget.storySlug,
    );
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionSelectBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _subscriptionSelectBloc,
      child: const SubscriptionSelectWidget(),
    );
  }
}
