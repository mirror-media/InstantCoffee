import 'package:flutter/material.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/paymentRecordBloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/paymentRecord.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MemberPaymentRecordPage extends StatefulWidget {
  @override
  _MemberPaymentRecordPageState createState() => _MemberPaymentRecordPageState();
}

class _MemberPaymentRecordPageState extends State<MemberPaymentRecordPage> {
  List<PaymentRecord> paymentRecordList = [];
  bool _isLoading = false;
  bool _isNoMore = false;

  @override
  void initState(){
    super.initState();
    _fetchPaymentRecords();
  }

  _fetchPaymentRecords() {
    context.read<PaymentRecordBloc>().add(FetchPaymentRecord());
  }

  _fetchMorePaymentRecords() {
    context.read<PaymentRecordBloc>().add(FetchMorePaymentRecord());
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
        if(state is PaymentRecordLoaded){
          if(state.paymentRecords == null || state.paymentRecords.length == 0){
            return _noRecordWidget();
          }
          paymentRecordList = state.paymentRecords;
        }
        else if(state is PaymentRecordLoadMore){
          if(state.paymentRecords.length > 0){
            paymentRecordList.addAll(state.paymentRecords);
          }
          else{
            _isNoMore = true;
          }
          if(state.paymentRecords.length < 12){
          _isNoMore = true;
          }
          _isLoading = false;
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo){
                  if (!_isLoading && scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent && !_isNoMore) {
                    _fetchMorePaymentRecords();
                    _isLoading = true;
                    return true;
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  separatorBuilder: (BuildContext context, int index){
                    return Material(
                      elevation: 1,
                      color: Colors.white,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                    );
                  },
                  itemCount: paymentRecordList.length,
                  itemBuilder: (context, index) {
                    return Material(
                      elevation: 1,
                      color: Colors.white,
                      child: _buildListItem(paymentRecordList[index]),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: _isLoading ? 50.0 : 0,
              color: Colors.transparent,
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          ],
        );
      }
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
        Container(
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
            onPressed: () {},
          ),
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