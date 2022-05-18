import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/paymentRecordBloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/models/paymentRecord.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/pages/memberCenter/shared/stateErrorWidget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MemberPaymentRecordPage extends StatefulWidget {
  final SubscriptionType subscriptionType;
  MemberPaymentRecordPage(this.subscriptionType);
  @override
  _MemberPaymentRecordPageState createState() =>
      _MemberPaymentRecordPageState();
}

class _MemberPaymentRecordPageState extends State<MemberPaymentRecordPage> {
  List<PaymentRecord> paymentRecordList = [];
  late SubscriptionType _subscriptionType;
  @override
  void initState() {
    super.initState();
    _fetchPaymentRecords();
    _subscriptionType = widget.subscriptionType;
  }

  _fetchPaymentRecords() {
    context.read<PaymentRecordBloc>().add(FetchPaymentRecord());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        '付款紀錄',
      ),
      backgroundColor: appColor,
    );
  }

  Widget _buildContent() {
    return BlocBuilder<PaymentRecordBloc, PaymentRecordState>(
        builder: (context, state) {
      if (state is PaymentRecordError) {
        return StateErrorWidget(() => _fetchPaymentRecords());
      } else if (state is PaymentRecordLoaded) {
        if (state.paymentRecords.length == 0) {
          return _noRecordWidget();
        }
        paymentRecordList = state.paymentRecords;
        bool hasApplePaymentRecord = paymentRecordList.any((paymentRecord) =>
            paymentRecord.paymentType == PaymentType.app_store);
        // do not to display apple payment record,
        // cuz there is no payment amount in apple payment record.
        if (hasApplePaymentRecord) {
          paymentRecordList.removeWhere((paymentRecord) =>
              paymentRecord.paymentType == PaymentType.app_store);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasApplePaymentRecord)
              Container(color: Colors.white, child: _applePaymentHint()),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.white,
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                      indent: 16,
                      endIndent: 16,
                    ),
                  );
                },
                itemCount: paymentRecordList.length,
                itemBuilder: (context, index) {
                  if (index == paymentRecordList.length - 1) {
                    return Material(
                      elevation: 1,
                      color: Colors.white,
                      child: _buildListItem(paymentRecordList[index]),
                    );
                  } else if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasApplePaymentRecord) ...[
                          Divider(
                            height: 0,
                          ),
                          SizedBox(height: 36),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: _otherRecordText(),
                          ),
                          SizedBox(height: 12),
                          Divider(
                            height: 0,
                          ),
                        ],
                        if (!hasApplePaymentRecord) SizedBox(height: 8),
                        Container(
                          color: Colors.white,
                          child: _buildListItem(paymentRecordList[index]),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      color: Colors.white,
                      child: _buildListItem(paymentRecordList[index]),
                    );
                  }
                },
              ),
            ),
          ],
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _applePaymentHint() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '如想了解您在 Apple Store 購買的訂單資訊，請至 ',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              TextSpan(
                text: 'Apple Store',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrlString(
                        "https://finance-app.itunes.apple.com/purchases");
                  },
              ),
              TextSpan(
                text: ' 查看。',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otherRecordText() {
    return Text(
      '其他付款紀錄',
      style: TextStyle(
        fontSize: 15,
      ),
    );
  }

  Widget _noRecordWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '找不到相關紀錄',
          style: TextStyle(
            color: Colors.black26,
            fontSize: 17,
          ),
        ),
        _subscriptionType == SubscriptionType.none ||
                _subscriptionType == SubscriptionType.subscribe_one_time
            ? Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: appColor),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        '升級 Premium 會員',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () =>
                      RouteGenerator.navigateToSubscriptionSelect(),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildListItem(PaymentRecord paymentRecord) {
    Widget statusText = Container();
    if (paymentRecord.paymentType == PaymentType.newebpay) {
      if (paymentRecord.isSuccess) {
        statusText = Text(
          '付款成功',
          style: TextStyle(
            color: Colors.black45,
            fontSize: 13,
          ),
        );
      } else {
        statusText = Text(
          '付款失敗',
          style: TextStyle(
            color: Color.fromARGB(240, 219, 23, 48),
            fontSize: 13,
          ),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              DateFormat('yyyy/MM/dd').format(paymentRecord.paymentDate),
              style: TextStyle(
                color: appColor,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 2),
            Text(
              paymentRecord.productName,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 4),
            Text(
              paymentRecord.paymentOrderNumber,
              style: TextStyle(color: Colors.black45, fontSize: 13),
            ),
            Text(
              paymentRecord.paymentMethod,
              style: TextStyle(color: Colors.black45, fontSize: 13),
            ),
            statusText
          ]),
          Text(
            '${paymentRecord.paymentCurrency}' +
                ' \$' +
                '${paymentRecord.paymentAmount}',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
