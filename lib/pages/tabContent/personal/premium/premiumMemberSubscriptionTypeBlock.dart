import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/shared/memberSubscriptionTypeTitleWidget.dart';

class PremiumMemberSubscriptionTypeBlock extends StatefulWidget {
  @override
  _PremiumMemberSubscriptionTypeBlockState createState() => _PremiumMemberSubscriptionTypeBlockState();
}

class _PremiumMemberSubscriptionTypeBlockState extends State<PremiumMemberSubscriptionTypeBlock> {
  @override
  void initState() {
    _fetchMemberSubscriptionType();
    super.initState();
  }

  _fetchMemberSubscriptionType() {
    context.read<MemberSubscriptionTypeCubit>().fetchMemberSubscriptionType();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberSubscriptionTypeCubit, MemberSubscriptionTypeState>(
      builder: (context, state) {
        if(state is MemberSubscriptionTypeLoadedState) {
          SubscriptionType? subscriptionType = state.subscriptionType;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildMemberTypeBlock(subscriptionType),
          );
        }
        
        // state is member subscription type init or loading
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _loadingWidget(),
        );
      }
    );
  }

  Widget _loadingWidget() {
    return Container(
      color: appColor,
      child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SpinKitWave(color: Colors.white, size: 51)
        ),
      )
    );
  }

  Widget _buildMemberTypeBlock(SubscriptionType? subscriptionType) {
    return Container(
      color: appColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _memberTypeTitle(subscriptionType)
      )
    );
  }

  Widget _memberTypeTitle(SubscriptionType? subscriptionType) {
    if(subscriptionType == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '加入 Premium 會員',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            '享受零廣告閱讀體驗',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '我的會員等級',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        SizedBox(height: 4),
        MemberSubscriptionTypeTitleWiget(
          subscriptionType: subscriptionType,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ],
    );
  }
}