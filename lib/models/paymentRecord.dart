class PaymentRecord {
  final String paymentId;
  final String paymentType;
  final String paymentCurrency;
  final int paymentAmount;
  final String paymentDate;
  final String paymentMethod;
  final String creditCardInfoLastFour;

  PaymentRecord({
    this.paymentId,
    this.paymentType,
    this.paymentCurrency,
    this.paymentAmount,
    this.paymentDate,
    this.paymentMethod,
    this.creditCardInfoLastFour,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      paymentId: json['id'],
      paymentType: json['type'],
      paymentCurrency: json['currency'],
      paymentAmount: json['amount'],
      paymentDate: json['payment_time'],
      paymentMethod: json['payment_method'],
      creditCardInfoLastFour: json['card_info_last_four'],
    );
  }
}