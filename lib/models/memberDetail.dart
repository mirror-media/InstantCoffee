import 'package:readr_app/helpers/EnumParser.dart';
import 'package:readr_app/models/paymentRecord.dart';

class MemberDetail {
  String frequency;
  DateTime periodFirstDatetime;
  DateTime periodEndDatetime;
  DateTime periodNextPayDatetime;
  PaymentType paymentType;
  String cardInfoLastFour;
  bool isCanceled;

  MemberDetail(
      {this.frequency,
      this.periodFirstDatetime,
      this.periodEndDatetime,
      this.periodNextPayDatetime,
      this.cardInfoLastFour,
      this.paymentType,
      this.isCanceled});

  factory MemberDetail.fromJson(Map<String, dynamic> json) {
    String frequency = '';
    if (json["frequency"] == 'yearly') {
      frequency = '年訂閱';
    } else if (json["frequency"] == 'monthly') {
      frequency = '月訂閱';
    }
    
    String paymentMethodJson = json['paymentMethod'];
    PaymentType paymentType;
    if(paymentMethodJson != null) {
      paymentType = paymentMethodJson.toEnum(PaymentType.values);
    }

    String cardInfoLastFour = '';
    if(json["newebpayPayment"] != null) {
      cardInfoLastFour = json["newebpayPayment"][0]["cardInfoLastFour"];
    }

    return MemberDetail(
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
        isCanceled: json["isCanceled"] == null ? false : json["isCanceled"]);
  }
}
