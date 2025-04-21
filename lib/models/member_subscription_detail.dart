import 'package:readr_app/helpers/enum_parser.dart';
import 'package:readr_app/models/payment_record.dart';

class MemberSubscriptionDetail {
  String frequency;
  DateTime? periodFirstDatetime;
  DateTime? periodEndDatetime;
  DateTime? periodNextPayDatetime;
  PaymentType? paymentType;
  final String? cardInfoLastFour;
  bool isCanceled;

  MemberSubscriptionDetail({
    required this.frequency,
    required this.periodFirstDatetime,
    required this.periodEndDatetime,
    required this.periodNextPayDatetime,
    required this.paymentType,
    this.cardInfoLastFour,
    required this.isCanceled,
  });

  factory MemberSubscriptionDetail.fromJson(Map<String, dynamic> json) {
    String frequency = '';
    if (json["frequency"] == 'yearly') {
      frequency = '年訂閱';
    } else if (json["frequency"] == 'monthly') {
      frequency = '月訂閱';
    }

    String? paymentMethodJson = json['paymentMethod'];
    PaymentType? paymentType;
    if (paymentMethodJson == 'line_pay') {
      paymentType = PaymentType.line_pay;
    } else if (paymentMethodJson != null) {
      paymentType = paymentMethodJson.toEnum(PaymentType.values);
    }

    String? cardInfoLastFour;
    final newsbpayPayment =json["newebpayPayment"] as List<dynamic>;

    if (json["newebpayPayment"] != null && newsbpayPayment.isNotEmpty) {
      cardInfoLastFour = json["newebpayPayment"][0]["cardInfoLastFour"];
    }

    return MemberSubscriptionDetail(
        frequency: frequency,
        periodFirstDatetime: json["periodFirstDatetime"] == null
            ? null
            : DateTime.parse(json["periodFirstDatetime"]).toLocal(),
        periodEndDatetime: json["periodFirstDatetime"] == null
            ? null
            : DateTime.parse(json["periodEndDatetime"]).toLocal(),
        periodNextPayDatetime: json["periodNextPayDatetime"] == null
            ? null
            : DateTime.parse(json["periodNextPayDatetime"]).toLocal(),
        paymentType: paymentType,
        cardInfoLastFour: cardInfoLastFour,
        isCanceled: json["isCanceled"] ?? false);
  }
}
