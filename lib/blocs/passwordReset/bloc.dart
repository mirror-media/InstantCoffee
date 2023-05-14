import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordReset/events.dart';
import 'package:readr_app/blocs/passwordReset/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/services/email_sign_in_service.dart';
import 'package:readr_app/widgets/logger.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvents, PasswordResetState>
    with Logger {
  final EmailSignInRepos emailSignInRepos;

  PasswordResetBloc({required this.emailSignInRepos})
      : super(PasswordResetInitState()) {
    on<ConfirmPasswordReset>(
      (event, emit) async {
        debugLog(event.toString());
        try {
          emit(PasswordResetLoading());
          bool isSuccess = await emailSignInRepos.confirmPasswordReset(
              event.code, event.newPassword);
          if (isSuccess) {
            emit(PasswordResetSuccess());
          } else {
            emit(PasswordResetFail());
          }
        } catch (e) {
          emit(PasswordResetError(
            error: determineException(e),
          ));
        }
      },
    );
  }
}
