import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:readr_app/blocs/memberCenter/memberDetail/member_detail_cubit.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/models/member_subscription_detail.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/models/payment_record.dart';
import 'package:readr_app/pages/memberCenter/shared/state_error_widget.dart';
import 'package:readr_app/pages/shared/member_subscription_type_title_widget.dart';

class MemberSubscriptionDetailPage extends StatefulWidget {
  final SubscriptionType subscriptionType;
  const MemberSubscriptionDetailPage({required this.subscriptionType});
  @override
  _MemberSubscriptionDetailPageState createState() =>
      _MemberSubscriptionDetailPageState();
}

class _MemberSubscriptionDetailPageState
    extends State<MemberSubscriptionDetailPage> {
  late SubscriptionType _subscriptionType;
  @override
  void initState() {
    super.initState();
    _subscriptionType = widget.subscriptionType;
    if (_subscriptionType == SubscriptionType.subscribe_monthly ||
        _subscriptionType == SubscriptionType.subscribe_yearly) {
      _getMemberDetail();
    }
  }

  _getMemberDetail() {
    context.read<MemberDetailCubit>().fetchMemberDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildBar(context), body: _buildContent(context));
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
        '我的方案細節',
      ),
      backgroundColor: appColor,
    );
  }

  Widget _buildContent(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (_subscriptionType == SubscriptionType.subscribe_monthly ||
        _subscriptionType == SubscriptionType.subscribe_yearly) {
      return BlocBuilder<MemberDetailCubit, MemberDetailState>(
        builder: (context, state) {
          if (state is MemberDetailLoad) {
            MemberSubscriptionDetail memberSubscriptionDetail =
                state.memberSubscriptionDetail;

            String period = '';
            if (memberSubscriptionDetail.periodFirstDatetime != null &&
                memberSubscriptionDetail.periodEndDatetime != null) {
              period =
                  '${DateFormat('yyyy/MM/dd').format(memberSubscriptionDetail.periodFirstDatetime!)}-${DateFormat('yyyy/MM/dd').format(memberSubscriptionDetail.periodEndDatetime!)}';
            }

            String paymentMethod =
                '信用卡自動續扣（${memberSubscriptionDetail.cardInfoLastFour}）';
            if (memberSubscriptionDetail.paymentType == PaymentType.app_store) {
              paymentMethod = 'Apple Pay 續扣';
            } else if (memberSubscriptionDetail.paymentType ==
                PaymentType.google_play) {
              paymentMethod = 'Google Pay 續扣';
            }
            if (memberSubscriptionDetail.isCanceled) paymentMethod = '-';
            String periodNextPayDatetime = memberSubscriptionDetail.isCanceled
                ? '-'
                : memberSubscriptionDetail.periodNextPayDatetime == null
                    ? ""
                    : DateFormat('yyyy/MM/dd').format(
                        memberSubscriptionDetail.periodNextPayDatetime!);
            return ListView(
              children: [
                Material(
                  elevation: 1,
                  child: Container(height: 16, color: Colors.white),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: _memberSubscriptionTypeWidget(_subscriptionType),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Container(
                      color: Colors.grey[300],
                      width: width,
                      height: 1,
                    ),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: _memberRowContent(
                        '訂閱方案', memberSubscriptionDetail.frequency),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Container(
                      color: Colors.grey[300],
                      width: width,
                      height: 1,
                    ),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: _memberRowContent('訂閱週期', period,
                        isCanceled: memberSubscriptionDetail.isCanceled),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Container(
                      color: Colors.grey[300],
                      width: width,
                      height: 1,
                    ),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: _memberRowContent('下次收費日', periodNextPayDatetime),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Container(
                      color: Colors.grey[300],
                      width: width,
                      height: 1,
                    ),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: _memberRowContent('付款方式', paymentMethod),
                  ),
                ),
                Material(
                  elevation: 1,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
                  ),
                ),
              ],
            );
          } else if (state is MemberDetailError) {
            return StateErrorWidget(() => _getMemberDetail());
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    return ListView(
      children: [
        Material(
          elevation: 1,
          child: Container(height: 16, color: Colors.white),
        ),
        Material(
          elevation: 1,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _memberSubscriptionTypeWidget(_subscriptionType),
          ),
        ),
        Material(
          elevation: 1,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
          ),
        ),
      ],
    );
  }

  Widget _memberRowContent(String title, String description,
      {bool isCanceled = false}) {
    if (isCanceled) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: appColor),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          '提醒您，您的訂閱將於本期結束後自動取消。',
          style:
              TextStyle(fontSize: 13, color: Color.fromARGB(229, 219, 23, 48)),
        ),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: const TextStyle(fontSize: 13, color: appColor),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        description,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    ]);
  }

  Widget _memberSubscriptionTypeWidget(SubscriptionType subscriptionType) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        '會員等級',
        style: TextStyle(fontSize: 13, color: appColor),
      ),
      const SizedBox(
        height: 4,
      ),
      MemberSubscriptionTypeTitleWiget(
        subscriptionType: subscriptionType,
        textStyle: const TextStyle(fontSize: 17),
      ),
    ]);
  }
}
