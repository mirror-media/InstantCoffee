class MemberDetail {
  String frequency;
  DateTime periodFirstDatetime;
  DateTime periodEndDatetime;
  DateTime periodNextPayDatetime;
  String paymentMethod;
  String cardInfoLastFour;
  bool isCanceled;

  MemberDetail(
      {this.frequency,
      this.periodFirstDatetime,
      this.periodEndDatetime,
      this.periodNextPayDatetime,
      this.cardInfoLastFour,
      this.paymentMethod,
      this.isCanceled});

  factory MemberDetail.fromJson(Map<String, dynamic> json) {
    String frequency = '';
    if (json["frequency"] == 'yearly') {
      frequency = '年訂閱';
    } else if (json["frequency"] == 'monthly') {
      frequency = '月訂閱';
    }
    return MemberDetail(
        frequency: frequency,
        periodFirstDatetime: DateTime.parse(json["periodFirstDatetime"]),
        periodEndDatetime: DateTime.parse(json["periodEndDatetime"]),
        periodNextPayDatetime: DateTime.parse(json["periodNextPayDatetime"]),
        paymentMethod: json["paymentMethod"],
        cardInfoLastFour: json["newebpayPayment"][0]["cardInfoLastFour"],
        isCanceled: json["isCanceled"] == null ? false : json["isCanceled"]);
  }
}
