import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/paymentRecord.dart';
import 'package:readr_app/services/paymentRecordService.dart';

part 'paymentRecordEvent.dart';
part 'paymentRecordState.dart';

class PaymentRecordBloc extends Bloc<PaymentRecordEvent, PaymentRecordState> {
  PaymentRecordBloc() : super(PaymentRecordInitial());
  String _token;
  FirebaseAuth _auth;
  PaymentRecordService paymentRecordService = PaymentRecordService();

  @override
  Stream<PaymentRecordState> mapEventToState(
    PaymentRecordEvent event,
  ) async* {
    print(event.toString());
    try {
      if(event is FetchPaymentRecord){
        _auth = FirebaseAuth.instance;
        _token = await _auth.currentUser.getIdToken();
        List<PaymentRecord> paymentRecords = await paymentRecordService.fetchPaymentRecord(
          _auth.currentUser.uid, _token);
        yield PaymentRecordLoaded(paymentRecords: paymentRecords);
      }
      else{
        List<PaymentRecord> paymentRecords = await paymentRecordService.fetchMorePaymentRecord(
          _auth.currentUser.uid, _token);
        yield PaymentRecordLoadMore(paymentRecords: paymentRecords);
      }
    } on SocketException {
      yield PaymentRecordError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield PaymentRecordError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield PaymentRecordError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield PaymentRecordError(
        error: UnknownException(e.toString()),
      );
    }
  }
}
