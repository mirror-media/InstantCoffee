import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/shared/memberSubscriptionTypeTitleWidget.dart';

class MemberSubscriptionTypeBlock extends StatefulWidget {
  @override
  _MemberSubscriptionTypeBlockState createState() => _MemberSubscriptionTypeBlockState();
}

class _MemberSubscriptionTypeBlockState extends State<MemberSubscriptionTypeBlock> {
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
          SubscriptionType subscriptionType = state.subscriptionType;
          return _buildMemberTypeBlock(subscriptionType);
        }
        
        // state is member subscription type init or loading
        return _loadingWidget();
      }
    );
  }

  Widget _loadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SpinKitWave(color: appColor, size: 48)
          )
        ),
      ),
    );
  }

  Widget _buildMemberTypeBlock(SubscriptionType subscriptionType) {
    double width = MediaQuery.of(context).size.width/3.3;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _memberTypeTitle(subscriptionType)
              ),
              if( subscriptionType == null ||
                subscriptionType == SubscriptionType.none ||
                subscriptionType == SubscriptionType.subscribe_one_time
              )
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: appColor,
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                  ),
                  child: Container(
                    width: width,
                    child: Center(
                      child: Text(
                        subscriptionType == null
                        ? '加入會員'
                        : '升級會員',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if(subscriptionType == null) {
                      RouteGenerator.navigateToLogin();
                    } else {
                      RouteGenerator.navigateToSubscriptionSelect();
                    }
                  }
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _memberTypeTitle(SubscriptionType subscriptionType) {
    if(subscriptionType == null) {
      return Text(
        '加入 Premium 會員\n享受零廣告閱讀體驗',
        style: TextStyle(
          fontSize: 16,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '我的會員等級',
          style: TextStyle(fontSize: 13, color: appColor),
        ),
        SizedBox(height: 4),
        MemberSubscriptionTypeTitleWiget(
          subscriptionType: subscriptionType,
          fontSize: 17,
        ),
      ],
    );
  }
}