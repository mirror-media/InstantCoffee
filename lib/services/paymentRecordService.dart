import 'dart:convert';
import 'package:readr_app/helpers/environment.dart';
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
          googlePlayPayment(orderBy: {transactionDatetime: desc}){
            amount
						transactionDatetime
          }
          appStorePayment(orderBy: {purchaseDate: desc}){
            amount
						purchaseDate
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
      Environment().config.memberApi,
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
        DateTime paymentDate = DateTime(2021);
        String paymentMethod;
        String creditCardInfoLastFour;
        String subscribeType = '單篇訂閱';
        bool isSuccess;
        if(subscription['frequency'] == 'monthly'){
          subscribeType = '月方案';
        } else if(subscription['frequency'] == 'yearly'){
          subscribeType = '年方案';
        }

        if(subscription['paymentMethod'] == 'newebpay' && subscription['newebpayPayment'] != null){
          subscription['newebpayPayment'].forEach((newebpayPayment){
            paymentAmount = newebpayPayment['amount'];
            creditCardInfoLastFour = newebpayPayment['cardInfoLastFour'];
            paymentMethod = '信用卡付款($creditCardInfoLastFour)';
            if(newebpayPayment['paymentTime'] != null){
              paymentDate = DateTime.parse(newebpayPayment['paymentTime']).toLocal();
            }
            if(newebpayPayment['status'] == 'SUCCESS'){
              isSuccess = true;
            }
            else{
              isSuccess = false;
            }
            if(newebpayPayment['frequency'] == 'monthly'){
              subscribeType = '月方案';
            }
            else if(newebpayPayment['frequency'] == 'yearly'){
              subscribeType = '年方案';
            }
            else{
              subscribeType = '單篇訂閱';
            }
            paymentRecord = PaymentRecord(
              paymentOrderNumber: paymentOrderNumber,
              subscribeType: subscribeType,
              paymentCurrency: paymentCurrency,
              paymentAmount: paymentAmount,
              paymentDate: paymentDate,
              paymentMethod: paymentMethod,
              isSuccess: isSuccess,
              paymentType: PaymentType.newebpay,
            );
            paymentRecords.add(paymentRecord);
          });
        }
        else if(subscription['paymentMethod'] == 'app_store'){
          paymentAmount = subscription['amount'];
          paymentMethod = 'App Store 續扣';
          if(subscription['appStorePayment'] != null){
            subscription['appStorePayment'].forEach((appStorePayment){
              if(appStorePayment['purchaseDate'] != null){
                paymentDate = DateTime.parse(appStorePayment['purchaseDate']).toLocal();
              }
              if(appStorePayment['amount'] != null){
                paymentAmount = appStorePayment['amount'].toInt();
              }
              paymentRecord = PaymentRecord(
                paymentOrderNumber: paymentOrderNumber,
                paymentType: PaymentType.app_store,
                paymentCurrency: paymentCurrency,
                paymentAmount: paymentAmount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
                isSuccess: isSuccess,
                subscribeType: subscribeType,
              );
              if(paymentAmount != null){
                paymentRecords.add(paymentRecord);
              }
            });
          }
        }
        else{
          paymentAmount = subscription['amount'];
          paymentMethod = 'Google Play 續扣';
          if(subscription['googlePlayPayment'] != null){
            subscription['googlePlayPayment'].forEach((googlePlayPayment){
              if(googlePlayPayment['transactionDatetime'] != null){
                paymentDate = DateTime.parse(googlePlayPayment['transactionDatetime']).toLocal();
              }
              if(googlePlayPayment['amount'] != null){
                paymentAmount = googlePlayPayment['amount'];
              }
              paymentRecord = PaymentRecord(
                paymentOrderNumber: paymentOrderNumber,
                paymentType: PaymentType.google_play,
                paymentCurrency: paymentCurrency,
                paymentAmount: paymentAmount,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
                isSuccess: isSuccess,
                subscribeType: subscribeType,
              );
              if(paymentAmount != null){
                paymentRecords.add(paymentRecord);
              }
            });
          }
        }
      });
    }
    paymentRecords.sort((a,b) => b.paymentDate.compareTo(a.paymentDate));
    return paymentRecords;
  }
}
