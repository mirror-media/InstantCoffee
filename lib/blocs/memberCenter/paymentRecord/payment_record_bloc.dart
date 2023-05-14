import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/models/payment_record.dart';
import 'package:readr_app/services/payment_record_service.dart';
import 'package:readr_app/widgets/logger.dart';

part 'payment_record_event.dart';
part 'payment_record_state.dart';

class PaymentRecordBloc extends Bloc<PaymentRecordEvent, PaymentRecordState>
    with Logger {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PaymentRecordService paymentRecordService = PaymentRecordService();
  PaymentRecordBloc() : super(PaymentRecordInitial()) {
    on<PaymentRecordEvent>(
      (event, emit) async {
        debugLog(event.toString());
        try {
          String token = await _auth.currentUser!.getIdToken();
          List<PaymentRecord> paymentRecords = await paymentRecordService
              .fetchPaymentRecord(_auth.currentUser!.uid, token);
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
