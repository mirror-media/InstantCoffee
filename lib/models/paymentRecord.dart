
class PaymentRecord {
  final String paymentOrderNumber;
  final String paymentType;
  final String paymentCurrency;
  final int paymentAmount;
  final DateTime paymentDate;
  final String paymentMethod;
  final bool isSuccess;

  PaymentRecord({
    this.paymentOrderNumber,
    this.paymentType,
    this.paymentCurrency,
    this.paymentAmount,
    this.paymentDate,
    this.paymentMethod,
    this.isSuccess
  });
}