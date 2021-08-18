import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/paymentRecord.dart';

class MemberPaymentRecordPage extends StatefulWidget {
  @override
  _MemberPaymentRecordPageState createState() => _MemberPaymentRecordPageState();
}

class _MemberPaymentRecordPageState extends State<MemberPaymentRecordPage> {
  final List<PaymentRecord> paymentRecordList = [
    PaymentRecord(
      paymentId: 'M202107160001',
      paymentType: '年方案',
      paymentCurrency: '\$',
      paymentAmount: 490,
      paymentDate: '2021/7/29',
      paymentMethod: 'Google Pay 續扣',
      creditCardInfoLastFour: null,
    ),
    PaymentRecord(
      paymentId: 'M202107160001',
      paymentType: '月方案',
      paymentCurrency: '\$',
      paymentAmount: 49,
      paymentDate: '2021/6/29',
      paymentMethod: 'Apple Pay 續扣',
      creditCardInfoLastFour: null,
    ),
    PaymentRecord(
      paymentId: 'M202107160001',
      paymentType: '月方案',
      paymentCurrency: '\$',
      paymentAmount: 49,
      paymentDate: '2021/5/29',
      paymentMethod: 'Apple Pay 續扣',
      creditCardInfoLastFour: null,
    ),
    PaymentRecord(
      paymentId: 'M202107160001',
      paymentType: '單篇訂閱',
      paymentCurrency: '\$',
      paymentAmount: 1,
      paymentDate: '2021/05/03',
      paymentMethod: '信用卡付款',
      creditCardInfoLastFour: '1092',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: paymentRecordList.length == 0
      ? _noRecordWidget()
      : ListView.separated(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
          itemCount: paymentRecordList.length + 1,
          itemBuilder: (context, index) {
            if (index == paymentRecordList.length) {
              return Container();
            }

            return _buildListItem(paymentRecordList[index]);
          },
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
        '付款紀錄',
      ),
      backgroundColor: appColor,
    );
  }

  Widget _noRecordWidget() {
    double height = MediaQuery.of(context).size.height/3;
    double width = MediaQuery.of(context).size.width/3*2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: height),
        Text(
          '找不到相關紀錄',
          style: TextStyle(
            color: Colors.black26,
            fontSize: 17,
          ),
        ),
        SizedBox(height: 24),
        RaisedButton(
          color: appColor,
          child: Container(
            width: width,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  '升級 Premium 會員',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildListItem(PaymentRecord paymentRecord) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentRecord.paymentDate,
                style: TextStyle(
                  color: appColor,
                  fontSize: 17,
                ),
              ),
              Text(
                paymentRecord.paymentType,
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 4),
              Text(
                paymentRecord.paymentId,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 13
                ),
              ),
              Text(
                paymentRecord.paymentMethod,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 13
                ),
              ),
            ]
          ),
          Text(
            '${paymentRecord.paymentCurrency}${paymentRecord.paymentAmount}',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}