import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/memberSubscriptionType/state.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/shared/member_subscription_type_title_widget.dart';

class MemberSubscriptionTypeBlock extends StatefulWidget {
  @override
  _MemberSubscriptionTypeBlockState createState() =>
      _MemberSubscriptionTypeBlockState();
}

class _MemberSubscriptionTypeBlockState
    extends State<MemberSubscriptionTypeBlock> {
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
    return BlocBuilder<MemberSubscriptionTypeCubit,
        MemberSubscriptionTypeState>(builder: (context, state) {
      if (state is MemberSubscriptionTypeLoadedState) {
        SubscriptionType? subscriptionType = state.subscriptionType;
        return _buildMemberTypeBlock(subscriptionType);
      }

      // state is member subscription type init or loading
      return _loadingWidget();
    });
  }

  Widget _loadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 10),
          ],
        ),
        child: const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: SpinKitWave(color: appColor, size: 48))),
      ),
    );
  }

  Widget _buildMemberTypeBlock(SubscriptionType? subscriptionType) {
    double width = MediaQuery.of(context).size.width / 3.3;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: _memberTypeTitle(subscriptionType)),
              if (subscriptionType == null ||
                  subscriptionType == SubscriptionType.none ||
                  subscriptionType == SubscriptionType.subscribe_one_time)
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: appColor,
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                    ),
                    child: SizedBox(
                      width: width,
                      child: Center(
                        child: Text(
                          subscriptionType == null ? '加入會員' : '升級會員',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (subscriptionType == null) {
                        RouteGenerator.navigateToLogin();
                      } else {
                        RouteGenerator.navigateToSubscriptionSelect();
                      }
                    }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _memberTypeTitle(SubscriptionType? subscriptionType) {
    if (subscriptionType == null) {
      return const Text(
        '加入 Premium 會員\n享受零廣告閱讀體驗',
        style: TextStyle(
          fontSize: 16,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '我的會員等級',
          style: TextStyle(fontSize: 13, color: appColor),
        ),
        const SizedBox(height: 4),
        MemberSubscriptionTypeTitleWiget(
          subscriptionType: subscriptionType,
          textStyle: const TextStyle(fontSize: 17),
        ),
      ],
    );
  }
}
