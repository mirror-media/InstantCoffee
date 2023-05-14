part of 'payment_record_bloc.dart';

@immutable
abstract class PaymentRecordState {}

class PaymentRecordInitial extends PaymentRecordState {}

class PaymentRecordLoaded extends PaymentRecordState {
  final List<PaymentRecord> paymentRecords;
  PaymentRecordLoaded({required this.paymentRecords});
}

class PaymentRecordError extends PaymentRecordState {
  final error;
  PaymentRecordError({this.error});
}
