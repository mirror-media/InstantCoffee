import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/events.dart';
import 'package:readr_app/blocs/passwordResetEmail/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/services/email_sign_in_service.dart';
import 'package:readr_app/widgets/logger.dart';

class PasswordResetEmailBloc
    extends Bloc<PasswordResetEmailEvents, PasswordResetEmailState>
    with Logger {
  final EmailSignInRepos emailSignInRepos;

  PasswordResetEmailBloc({required this.emailSignInRepos})
      : super(PasswordResetEmailInitState()) {
    on<SendPasswordResetEmail>(
      (event, emit) async {
        debugLog(event.toString());
        try {
          emit(PasswordResetEmailSending());
          FirebaseLoginStatus firebaseLoginStatus =
              await emailSignInRepos.sendPasswordResetEmail(event.email);
          if (firebaseLoginStatus.status == FirebaseStatus.Success) {
            emit(PasswordResetEmailSendingSuccess());
          } else if (firebaseLoginStatus.status == FirebaseStatus.Error) {
            if (firebaseLoginStatus.message == 'user-not-found') {
              emit(EmailUserNotFound());
            } else {
              emit(PasswordResetEmailSendingFail());
            }
          }
        } catch (e) {
          emit(PasswordResetEmailError(
            error: determineException(e),
          ));
        }
      },
    );
  }
}
