enum PaymentType{
  newebpay,
  app_store,
  google_play,
}

class PaymentRecord {
  final String paymentOrderNumber;
  final String productName;
  final PaymentType paymentType;
  final String paymentMethod;
  final DateTime paymentDate;
  final bool isSuccess;

  final String? paymentCurrency;
  final int? paymentAmount;

  PaymentRecord({
    required this.paymentOrderNumber,
    required this.productName,
    required this.paymentType,
    required this.paymentMethod,
    required this.paymentDate,
    this.isSuccess = false,

    this.paymentCurrency,
    this.paymentAmount,
  });
}