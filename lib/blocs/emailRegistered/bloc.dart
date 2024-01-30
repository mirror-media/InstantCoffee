import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailRegistered/events.dart';
import 'package:readr_app/blocs/emailRegistered/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/services/email_sign_in_service.dart';
import 'package:readr_app/services/member_service.dart';
import 'package:readr_app/widgets/logger.dart';

class EmailRegisteredBloc
    extends Bloc<EmailRegisteredEvents, EmailRegisteredState> with Logger {
  final EmailSignInRepos emailSignInRepos;

  EmailRegisteredBloc({required this.emailSignInRepos})
      : super(EmailRegisteredInitState()) {
    on<CreateUserWithEmailAndPassword>(
      (event, emit) async {
        debugLog(event.toString());
        try {
          emit(EmailRegisteredLoading());
          FirebaseLoginStatus frebaseLoginStatus = await emailSignInRepos
              .createUserWithEmailAndPassword(event.email, event.password);
          if (frebaseLoginStatus.status == FirebaseStatus.Success) {
            FirebaseAuth auth = FirebaseAuth.instance;
            MemberService memberService = MemberService();

            String? token = await auth.currentUser!.getIdToken();
            if (token != null) {
              bool createSuccess = await memberService.createMember(
                  auth.currentUser!.email, auth.currentUser!.uid, token);

              if (createSuccess) {
                emit(EmailRegisteredSuccess());
              } else {
                try {
                  await auth.currentUser!.delete();
                } catch (e) {
                  debugLog(e);
                  await auth.signOut();
                }
                emit(EmailRegisteredFail(
                  error: UnknownException('Create member fail'),
                ));
              }
            } else if (frebaseLoginStatus.status == FirebaseStatus.Error) {
              if (frebaseLoginStatus.message == 'email-already-in-use') {
                emit(EmailAlreadyInUse());
              } else {
                emit(EmailRegisteredFail(
                  error: UnknownException(frebaseLoginStatus.message),
                ));
              }
            }
          }
        } catch (e) {
          emit(EmailRegisteredFail(
            error: determineException(e),
          ));
        }
      },
    );
  }
}
