part of 'paymentRecordBloc.dart';

@immutable
abstract class PaymentRecordState {}

class PaymentRecordInitial extends PaymentRecordState {}

class PaymentRecordLoaded extends PaymentRecordState {
  final List<PaymentRecord> paymentRecords;
  PaymentRecordLoaded({this.paymentRecords});
}

class PaymentRecordLoadMore extends PaymentRecordState {
  final List<PaymentRecord> paymentRecords;
  PaymentRecordLoadMore({this.paymentRecords});
}

class PaymentRecordError extends PaymentRecordState {
  final error;
  PaymentRecordError({this.error});
}
