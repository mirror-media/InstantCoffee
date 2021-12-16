enum PaymentType{
  newebpay,
  appStore,
  googlePlay,
}
class PaymentRecord {
  final String paymentOrderNumber;
  final String subscribeType;
  final String paymentCurrency;
  final int paymentAmount;
  final DateTime paymentDate;
  final String paymentMethod;
  final bool isSuccess;
  final PaymentType paymentType;

  PaymentRecord({
    this.paymentOrderNumber,
    this.subscribeType,
    this.paymentCurrency,
    this.paymentAmount,
    this.paymentDate,
    this.paymentMethod,
    this.isSuccess,
    this.paymentType,
  });
}