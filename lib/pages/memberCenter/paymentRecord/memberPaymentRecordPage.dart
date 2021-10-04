import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/paymentRecordBloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/models/paymentRecord.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/hintToWebsitePage.dart';


class MemberPaymentRecordPage extends StatefulWidget {
  final SubscritionType subscritionType;
  MemberPaymentRecordPage(this.subscritionType);
  @override
  _MemberPaymentRecordPageState createState() => _MemberPaymentRecordPageState();
}

class _MemberPaymentRecordPageState extends State<MemberPaymentRecordPage> {
  List<PaymentRecord> paymentRecordList = [];
  SubscritionType _subscritionType;
  @override
  void initState(){
    super.initState();
    _fetchPaymentRecords();
    _subscritionType = widget.subscritionType;
  }

  _fetchPaymentRecords() {
    context.read<PaymentRecordBloc>().add(FetchPaymentRecord());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: SafeArea(child: _buildContent(),),
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

  Widget _buildContent(){
    return BlocBuilder<PaymentRecordBloc, PaymentRecordState>(
      builder: (context, state){
        if(state is PaymentRecordError){
          return _errorWidget();
        }
        else if(state is PaymentRecordLoaded){
          if(state.paymentRecords == null || state.paymentRecords.length == 0){
            return _noRecordWidget();
          }
          paymentRecordList = state.paymentRecords;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            separatorBuilder: (BuildContext context, int index){
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
              if(index == paymentRecordList.length - 1){
                return Material(
                  elevation: 1,
                  color: Colors.white,
                  child: _buildListItem(paymentRecordList[index]),
                );
              }
              else{
                return Container(
                  color: Colors.white,
                  child: _buildListItem(paymentRecordList[index]),
                );
              }
            },
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Widget _errorWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '載入失敗',
          style: TextStyle(
            color: Colors.black26,
            fontSize: 17,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: appColor),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  '重新載入',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onPressed: () => _fetchPaymentRecords(),
          ),
        ),
      ],
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
        _subscritionType == SubscritionType.none 
          || _subscritionType == SubscritionType.subscribe_one_time ? Container(
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
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HintToWebsitePage('升級 Premium 會員'))
              // Hide until in-app purchase ready
              // MaterialPageRoute(builder: (context) => SubscriptionSelectPage(buttonText))
            ),
          ),
        ) : Container(),
      ],
    );
  }

  Widget _buildListItem(PaymentRecord paymentRecord) {
    Widget statusText;
    if(paymentRecord.isSuccess){
      statusText = Text('付款成功',
        style:TextStyle(
          color: Colors.black45,
          fontSize: 13,
        ),
      );
    }
    else{
      statusText = Text('付款失敗',
        style:TextStyle(
          color: Color.fromARGB(240, 219, 23, 48),
          fontSize: 13,
        ),
      );
    }
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
                DateFormat('yyyy/MM/dd').format(paymentRecord.paymentDate),
                style: TextStyle(
                  color: appColor,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 2),
              Text(
                paymentRecord.paymentType,
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 4),
              Text(
                paymentRecord.paymentOrderNumber,
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
              statusText
            ]
          ),
          Text(
            '${paymentRecord.paymentCurrency}'+' \$'+'${paymentRecord.paymentAmount}',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}