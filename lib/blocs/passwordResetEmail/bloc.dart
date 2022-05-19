import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/events.dart';
import 'package:readr_app/blocs/passwordResetEmail/states.dart';
import 'package:readr_app/helpers/errorHelper.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';

class PasswordResetEmailBloc
    extends Bloc<PasswordResetEmailEvents, PasswordResetEmailState> {
  final EmailSignInRepos emailSignInRepos;

  PasswordResetEmailBloc({required this.emailSignInRepos})
      : super(PasswordResetEmailInitState()) {
    on<SendPasswordResetEmail>(
      (event, emit) async {
        print(event.toString());
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
