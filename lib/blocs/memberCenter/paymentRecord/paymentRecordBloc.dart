import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:readr_app/helpers/errorHelper.dart';
import 'package:readr_app/models/paymentRecord.dart';
import 'package:readr_app/services/paymentRecordService.dart';

part 'paymentRecordEvent.dart';
part 'paymentRecordState.dart';

class PaymentRecordBloc extends Bloc<PaymentRecordEvent, PaymentRecordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PaymentRecordService paymentRecordService = PaymentRecordService();
  PaymentRecordBloc() : super(PaymentRecordInitial()) {
    on<PaymentRecordEvent>(
      (event, emit) async {
        print(event.toString());
        try {
          String _token = await _auth.currentUser!.getIdToken();
          List<PaymentRecord> paymentRecords = await paymentRecordService
              .fetchPaymentRecord(_auth.currentUser!.uid, _token);
          emit(PaymentRecordLoaded(paymentRecords: paymentRecords));
        } catch (e) {
          emit(PaymentRecordError(
            error: determineException(e),
          ));
        }
      },
    );
  }
}
