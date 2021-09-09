import 'package:flutter/material.dart';
import 'package:readr_app/blocs/memberDetail/memberDetailCubit.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/models/memberDetail.dart';
import 'package:intl/intl.dart';

class MemberSubscriptionDetailPage extends StatefulWidget {
  final bool isPremium;
  MemberSubscriptionDetailPage({this.isPremium = true});
  @override
  _MemberSubscriptionDetailPageState createState() =>
      _MemberSubscriptionDetailPageState();
}

class _MemberSubscriptionDetailPageState
    extends State<MemberSubscriptionDetailPage> {
  bool isPremium;
  @override
  void initState() {
    super.initState();
    isPremium = widget.isPremium;
    if (isPremium) _getMemberDetail();
  }

  _getMemberDetail() {
    context.read<MemberDetailCubit>().fetchMemberDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildBar(context), body: _buildContent(context));
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        '我的方案細節',
      ),
      backgroundColor: appColor,
    );
  }

  Widget _buildContent(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (isPremium) {
      return BlocBuilder<MemberDetailCubit, MemberDetailState>(
        builder: (context, state) {
          if (state is MemberDetailLoad) {
            MemberDetail memberDetail = state.memberDetail;
            String period =
                '${DateFormat('yyyy/MM/dd').format(memberDetail.periodFirstDatetime)}-${DateFormat('yyyy/MM/dd').format(memberDetail.periodEndDatetime)}';
            String paymentMethod = '信用卡自動續扣（${memberDetail.cardInfoLastFour}）';
            if (memberDetail.paymentMethod == 'applepay') {
              paymentMethod = 'Apple Pay 續扣';
            } else if (memberDetail.paymentMethod == 'androidpay') {
              paymentMethod = 'Google Pay 續扣';
            }
            if (memberDetail.isCanceled) paymentMethod = '-';
            String periodNextPayDatetime = memberDetail.isCanceled
                ? '-'
                : DateFormat('yyyy/MM/dd')
                    .format(memberDetail.periodNextPayDatetime);
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
                    child: _memberRowContent('會員等級', 'Premium 會員'),
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
                    child: _memberRowContent('訂閱方案', memberDetail.frequency),
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
                        isCanceled: memberDetail.isCanceled),
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
                  child: _memberRowContent('會員等級', 'Premium 會員'),
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
            child: _memberRowContent('會員等級', 'Basic 會員'),
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
          style: TextStyle(fontSize: 13, color: appColor),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '提醒您，您的訂閱將於本期結束後自動取消。',
          style:
              TextStyle(fontSize: 13, color: Color.fromARGB(229, 219, 23, 48)),
        ),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(fontSize: 13, color: appColor),
      ),
      SizedBox(
        height: 4,
      ),
      Text(
        description,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    ]);
  }
}
