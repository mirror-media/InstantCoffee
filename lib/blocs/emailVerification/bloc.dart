import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailVerification/events.dart';
import 'package:readr_app/blocs/emailVerification/states.dart';
import 'package:readr_app/helpers/errorHelper.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvents, EmailVerificationState> {
  final EmailSignInRepos emailSignInRepos;

  EmailVerificationBloc({required this.emailSignInRepos})
      : super(EmailVerificationInitState()) {
    on<SendEmailVerification>(
      (event, emit) async {
        print(event.toString());
        try {
          emit(SendingEmailVerification());
          FirebaseLoginStatus firebaseLoginStatus =
              await emailSignInRepos.sendEmailVerification(
            event.email,
            event.redirectUrl,
          );
          if (firebaseLoginStatus.status == FirebaseStatus.Success) {
            emit(SendingEmailVerificationSuccess());
          } else if (firebaseLoginStatus.status == FirebaseStatus.Error) {
            emit(SendingEmailVerificationFail());
          }
        } catch (e) {
          emit(EmailVerificationError(
            error: determineException(e),
          ));
        }
      },
    );
  }
}
