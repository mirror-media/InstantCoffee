import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailLogin/events.dart';
import 'package:readr_app/blocs/emailLogin/states.dart';
import 'package:readr_app/helpers/errorHelper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';

class EmailLoginBloc extends Bloc<EmailLoginEvents, EmailLoginState> {
  final EmailSignInRepos emailSignInRepos;

  EmailLoginBloc({required this.emailSignInRepos})
      : super(EmailLoginInitState()) {
    on<SignInWithEmailAndPassword>((event, emit) async {
      print(event.toString());
      try {
        emit(EmailLoginLoading());
        FirebaseLoginStatus frebaseLoginStatus = await emailSignInRepos
            .signInWithEmailAndPassword(event.email, event.password);
        if (frebaseLoginStatus.status == FirebaseStatus.Success) {
          emit(EmailLoginSuccess());
        } else if (frebaseLoginStatus.status == FirebaseStatus.Error) {
          if (frebaseLoginStatus.message == 'wrong-password') {
            emit(EmailLoginFail());
          } else {
            emit(EmailLoginError(
              error: UnknownException(frebaseLoginStatus.message),
            ));
          }
        }
      } catch (e) {
        emit(EmailLoginError(
          error: determineException(e),
        ));
      }
    });
  }
}
