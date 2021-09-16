import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/paymentRecord.dart';

class PaymentRecordService {
  ApiBaseHelper _helper = ApiBaseHelper();
  int _first = 12, _skip = 0;

  static Map<String, String> getHeaders(String token) {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }

    return headers;
  }

  Future<List<PaymentRecord>> fetchPaymentRecord(String firebaseId, String token) async {
    String query = """
    query fetchSubscriptionPayments(
      \$firebaseId: String!,
      \$first: Int,
      \$skip: Int,
      ) {
      member(where: { firebaseId: \$firebaseId }) {
        subscription(
          orderBy: [{ periodEndDatetime: desc }],
          first: \$first,
          skip: \$skip,
          ) {
          orderNumber
          frequency
          currency
          paymentMethod
          amount
          newebpayPayment(orderBy: [{ paymentTime: desc }]) {
            amount
            paymentMethod
            paymentTime
            cardInfoLastFour
          }
          androidpayPayment(orderBy: [{updatedAt: desc}]){
            updatedAt
          }
          applepayPayment(orderBy: [{updatedAt: desc}]){
            updatedAt
          }
        }
      }
    }
    """;
    Map<String, dynamic> variables = {
      "firebaseId": "$firebaseId",
      "first": _first,
      "skip": _skip
    };
    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      env.baseConfig.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: getHeaders(token),
    );

    List<PaymentRecord> paymentRecords = [];
    if (jsonResponse['data']['member']['subscription'] != null) {
      jsonResponse['data']['member']['subscription'].forEach((subscription){
        PaymentRecord paymentRecord;
        String paymentCurrency = subscription['currency'] == null ? 'TWD':subscription['currency'];
        String paymentOrderNumber = subscription['orderNumber'];
        int paymentAmount;
        String paymentDate;
        String paymentMethod;
        String creditCardInfoLastFour;
        String paymentType;
        if(subscription['frequency'] == 'monthly'){
          paymentType = '月方案';
        }
        else if(subscription['frequency'] == 'yearly'){
          paymentType = '年方案';
        }
        else{
          paymentType = '單篇訂閱';
        }
        if(subscription['paymentMethod'] == 'newebpay' && subscription['newebpayPayment'] != null){
          subscription['newebpayPayment'].forEach((newebpayPayment){
            paymentAmount = newebpayPayment['amount'];
            creditCardInfoLastFour = newebpayPayment['cardInfoLastFour'];
            paymentMethod = newebpayPayment['paymentMethod'] + '($creditCardInfoLastFour)';
            if(newebpayPayment['paymentTime'] != null){
              DateTime dateTime = DateTime.parse(newebpayPayment['paymentTime']);
              paymentDate = DateFormat('yyyy/MM/dd').format(dateTime);
            }
            else{
              DateTime dateTime = DateTime.utc(2021);
              paymentDate = DateFormat('yyyy/MM/dd').format(dateTime);
            }
            paymentRecord = PaymentRecord(
              paymentOrderNumber: paymentOrderNumber,
              paymentType: paymentType,
              paymentCurrency: paymentCurrency,
              paymentAmount: paymentAmount,
              paymentDate: paymentDate,
              paymentMethod: paymentMethod,
            );
            paymentRecords.add(paymentRecord);
          });
        }
        else if(subscription['paymentMethod'] == 'applepay'){
          paymentAmount = subscription['amount'];
          paymentMethod = 'Apple Pay 續扣';
          if(subscription['applepayPayment'] != null){
            subscription['applepayPayment'].forEach((applepayPayment){
              if(applepayPayment['updatedAt'] != null){
                DateTime dateTime = DateTime.parse(applepayPayment['updatedAt']);
                paymentDate = DateFormat('yyyy/MM/dd').format(dateTime);
              }
              else{
                DateTime dateTime = DateTime.utc(2021);
                paymentDate = DateFormat('yyyy/MM/dd').format(dateTime);
              }
              paymentRecord = PaymentRecord(
                paymentOrderNumber: paymentOrderNumber,
                paymentType: paymentType,
                paymentCurrency: paymentCurrency,
                paymentAmount: paymentAmount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
              );
              paymentRecords.add(paymentRecord);
            });
          }
        }
        else{
          paymentAmount = subscription['amount'];
          paymentMethod = 'Google Pay 續扣';
          if(subscription['androidpayPayment'] != null){
            subscription['androidpayPayment'].forEach((androidpayPayment){
              if(androidpayPayment['updatedAt'] != null){
                DateTime dateTime = DateTime.parse(androidpayPayment['updatedAt']);
                paymentDate = DateFormat('yyyy/MM/dd').format(dateTime);
              }
              else{
                DateTime dateTime = DateTime.utc(2021);
                paymentDate = DateFormat('yyyy/MM/dd').format(dateTime);
              }
              paymentRecord = PaymentRecord(
                paymentOrderNumber: paymentOrderNumber,
                paymentType: paymentType,
                paymentCurrency: paymentCurrency,
                paymentAmount: paymentAmount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
              );
              paymentRecords.add(paymentRecord);
            });
          }
        }
      });
    }
    return paymentRecords;
  }

  Future<List<PaymentRecord>> fetchMorePaymentRecord(String firebaseId, String token) async {
    _skip = _skip + _first;
    return fetchPaymentRecord(firebaseId,token);
  }
}
