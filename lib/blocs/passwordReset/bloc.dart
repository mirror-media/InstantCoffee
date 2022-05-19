import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordReset/events.dart';
import 'package:readr_app/blocs/passwordReset/states.dart';
import 'package:readr_app/helpers/errorHelper.dart';
import 'package:readr_app/services/emailSignInService.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvents, PasswordResetState> {
  final EmailSignInRepos emailSignInRepos;

  PasswordResetBloc({required this.emailSignInRepos})
      : super(PasswordResetInitState()) {
    on<ConfirmPasswordReset>(
      (event, emit) async {
        print(event.toString());
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
