import 'dart:convert';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/models/graphql_body.dart';
import 'package:readr_app/models/payment_record.dart';
import 'package:readr_app/services/member_service.dart';

class PaymentRecordService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  PaymentRecord _changeNewebpayPaymentJsonToPaymentRecord(
    String paymentOrderNumber,
    String paymentCurrency,
    dynamic newebpayPayment,
  ) {
    late String productName;
    if (newebpayPayment['frequency'] == 'monthly') {
      productName = '月方案';
    } else if (newebpayPayment['frequency'] == 'yearly') {
      productName = '年方案';
    } else {
      productName = '單篇訂閱';
    }

    String creditCardInfoLastFour = newebpayPayment['cardInfoLastFour'];
    String paymentMethod = '信用卡付款($creditCardInfoLastFour)';

    DateTime paymentDate = DateTime(1990, 1, 1);
    if (newebpayPayment['paymentTime'] != null) {
      paymentDate = DateTime.parse(newebpayPayment['paymentTime']).toLocal();
    }

    bool isSuccess = newebpayPayment['status'] == 'SUCCESS';

    int paymentAmount = newebpayPayment['amount'];

    return PaymentRecord(
      paymentOrderNumber: paymentOrderNumber,
      productName: productName,
      paymentType: PaymentType.newebpay,
      paymentMethod: paymentMethod,
      paymentDate: paymentDate,
      isSuccess: isSuccess,
      paymentCurrency: paymentCurrency,
      paymentAmount: paymentAmount,
    );
  }

  PaymentRecord _changeAppStorePaymentJsonToPaymentRecord(
    String paymentOrderNumber,
    dynamic appStorePayment,
  ) {
    // TODO: need to fix after api gateway update
    // if(appStorePayment['productId'] == Environment().config.monthSubscriptionId){
    //   productName = '月方案';
    // }
    String productName = '月方案';

    String paymentMethod = 'App Store 續扣';

    DateTime paymentDate = DateTime(1990, 1, 1);
    if (appStorePayment['purchaseDate'] != null) {
      paymentDate = DateTime.parse(appStorePayment['purchaseDate']).toLocal();
    }

    bool isSuccess = appStorePayment['status'] == 'SUCCESS';

    return PaymentRecord(
      paymentOrderNumber: paymentOrderNumber,
      productName: productName,
      paymentType: PaymentType.app_store,
      paymentMethod: paymentMethod,
      paymentDate: paymentDate,
      isSuccess: isSuccess,
    );
  }

  PaymentRecord _changeGooglePlayPaymentJsonToPaymentRecord(
    String paymentOrderNumber,
    String paymentCurrency,
    dynamic googlePlayPayment,
  ) {
    // TODO: need to fix after api gateway update
    // if(googlePlayPayment['productId'] == Environment().config.monthSubscriptionId){
    //   productName = '月方案';
    // }
    String productName = '月方案';

    String paymentMethod = 'Google Play 續扣';

    DateTime paymentDate = DateTime(1990, 1, 1);
    if (googlePlayPayment['transactionDatetime'] != null) {
      paymentDate =
          DateTime.parse(googlePlayPayment['transactionDatetime']).toLocal();
    }

    bool isSuccess = googlePlayPayment['status'] == 'SUCCESS';

    int paymentAmount = googlePlayPayment['amount'];

    return PaymentRecord(
      paymentOrderNumber: paymentOrderNumber,
      productName: productName,
      paymentType: PaymentType.google_play,
      paymentMethod: paymentMethod,
      paymentDate: paymentDate,
      isSuccess: isSuccess,
      paymentCurrency: paymentCurrency,
      paymentAmount: paymentAmount,
    );
  }

  Future<List<PaymentRecord>> fetchPaymentRecord(
      String firebaseId, String token) async {
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
          paymentMethod
          currency
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
						purchaseDate
          }
        }
      }
    }
    """;
    Map<String, dynamic> variables = {"firebaseId": firebaseId};
    GraphqlBody graphqlBody = GraphqlBody(
      operationName: '',
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      Environment().config.memberApi,
      jsonEncode(graphqlBody.toJson()),
      headers: MemberService.getHeaders(token),
    );

    List<PaymentRecord> paymentRecords = [];
    List subscriptionList =
        jsonResponse['data']['member']['subscription'] ?? [];
    for (var subscription in subscriptionList) {
      String paymentCurrency = subscription['currency'] ?? 'TWD';
      String paymentOrderNumber = subscription['orderNumber'];

      if (subscription['paymentMethod'] == PaymentType.newebpay.name) {
        List newebpayPaymentList = subscription['newebpayPayment'] ?? [];
        for (var newebpayPayment in newebpayPaymentList) {
          PaymentRecord paymentRecord =
              _changeNewebpayPaymentJsonToPaymentRecord(
                  paymentOrderNumber, paymentCurrency, newebpayPayment);

          paymentRecords.add(paymentRecord);
        }
      } else if (subscription['paymentMethod'] == PaymentType.app_store.name) {
        List appStorePaymentList = subscription['appStorePayment'] ?? [];
        for (var appStorePayment in appStorePaymentList) {
          PaymentRecord paymentRecord =
              _changeAppStorePaymentJsonToPaymentRecord(
                  paymentOrderNumber, appStorePayment);

          paymentRecords.add(paymentRecord);
        }
      } else if (subscription['paymentMethod'] ==
          PaymentType.google_play.name) {
        List googlePlayPaymentList = subscription['googlePlayPayment'] ?? [];
        for (var googlePlayPayment in googlePlayPaymentList) {
          PaymentRecord paymentRecord =
              _changeGooglePlayPaymentJsonToPaymentRecord(
                  paymentOrderNumber, paymentCurrency, googlePlayPayment);

          paymentRecords.add(paymentRecord);
        }
      }
    }
    paymentRecords.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    return paymentRecords;
  }
}
