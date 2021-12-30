enum PaymentType{
  newebpay,
  app_store,
  google_play,
}

class PaymentRecord {
  final String paymentOrderNumber;
  final String productName;
  final String paymentCurrency;
  final int paymentAmount;
  final DateTime paymentDate;
  final String paymentMethod;
  final bool isSuccess;
  final PaymentType paymentType;

  PaymentRecord({
    this.paymentOrderNumber,
    this.productName,
    this.paymentCurrency,
    this.paymentAmount,
    this.paymentDate,
    this.paymentMethod,
    this.isSuccess,
    this.paymentType,
  });
}