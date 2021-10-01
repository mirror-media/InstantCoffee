import 'dart:convert';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/apiBaseHelper.dart';
import 'package:readr_app/models/graphqlBody.dart';
import 'package:readr_app/models/paymentRecord.dart';

class PaymentRecordService {
  ApiBaseHelper _helper = ApiBaseHelper();

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
      \$firebaseId: String!
      ) {
      member(where: { firebaseId: \$firebaseId }) {
        subscription(
          orderBy: { createdAt: desc }
          ) {
          orderNumber
          frequency
          currency
          paymentMethod
          amount
          newebpayPayment(orderBy: { paymentTime: desc }) {
            status
            frequency
            amount
            paymentMethod
            paymentTime
            cardInfoLastFour
          }
          androidpayPayment(orderBy: {updatedAt: desc}){
            updatedAt
          }
          applepayPayment(orderBy: {updatedAt: desc}){
            updatedAt
          }
        }
      }
    }
    """;
    Map<String, dynamic> variables = {
      "firebaseId": "$firebaseId"
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
        DateTime paymentDate = DateTime.utc(2021);
        String paymentMethod;
        String creditCardInfoLastFour;
        String paymentType;
        bool isSuccess;
        if(subscription['paymentMethod'] == 'newebpay' && subscription['newebpayPayment'] != null){
          subscription['newebpayPayment'].forEach((newebpayPayment){
            paymentAmount = newebpayPayment['amount'];
            creditCardInfoLastFour = newebpayPayment['cardInfoLastFour'];
            paymentMethod = newebpayPayment['paymentMethod'] + '($creditCardInfoLastFour)';
            if(newebpayPayment['paymentTime'] != null){
              paymentDate = DateTime.parse(newebpayPayment['paymentTime']);
            }
            if(newebpayPayment['status'] == 'SUCCESS'){
              isSuccess = true;
            }
            else{
              isSuccess = false;
            }
            if(newebpayPayment['frequency'] == 'monthly'){
              paymentType = '月方案';
            }
            else if(newebpayPayment['frequency'] == 'yearly'){
              paymentType = '年方案';
            }
            else{
              paymentType = '單篇訂閱';
            }
            paymentRecord = PaymentRecord(
              paymentOrderNumber: paymentOrderNumber,
              paymentType: paymentType,
              paymentCurrency: paymentCurrency,
              paymentAmount: paymentAmount,
              paymentDate: paymentDate,
              paymentMethod: paymentMethod,
              isSuccess: isSuccess
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
                paymentDate = DateTime.parse(applepayPayment['updatedAt']);
              }
              paymentRecord = PaymentRecord(
                paymentOrderNumber: paymentOrderNumber,
                paymentType: paymentType,
                paymentCurrency: paymentCurrency,
                paymentAmount: paymentAmount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
                isSuccess: isSuccess
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
                paymentDate = DateTime.parse(androidpayPayment['updatedAt']);
              }
              paymentRecord = PaymentRecord(
                paymentOrderNumber: paymentOrderNumber,
                paymentType: paymentType,
                paymentCurrency: paymentCurrency,
                paymentAmount: paymentAmount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
                isSuccess: isSuccess
              );
              paymentRecords.add(paymentRecord);
            });
          }
        }
      });
    }
    paymentRecords.sort((a,b) => b.paymentDate.compareTo(a.paymentDate));
    return paymentRecords;
  }
}
