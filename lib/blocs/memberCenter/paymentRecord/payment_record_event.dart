part of 'payment_record_bloc.dart';

@immutable
abstract class PaymentRecordEvent {}

class FetchPaymentRecord extends PaymentRecordEvent {
  @override
  String toString() {
    return 'Fetch payment records';
  }
}
