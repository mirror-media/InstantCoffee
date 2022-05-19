import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailRegistered/events.dart';
import 'package:readr_app/blocs/emailRegistered/states.dart';
import 'package:readr_app/helpers/errorHelper.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/services/memberService.dart';

class EmailRegisteredBloc
    extends Bloc<EmailRegisteredEvents, EmailRegisteredState> {
  final EmailSignInRepos emailSignInRepos;

  EmailRegisteredBloc({required this.emailSignInRepos})
      : super(EmailRegisteredInitState()) {
    on<CreateUserWithEmailAndPassword>(
      (event, emit) async {
        print(event.toString());
        try {
          emit(EmailRegisteredLoading());
          FirebaseLoginStatus frebaseLoginStatus = await emailSignInRepos
              .createUserWithEmailAndPassword(event.email, event.password);
          if (frebaseLoginStatus.status == FirebaseStatus.Success) {
            FirebaseAuth auth = FirebaseAuth.instance;
            MemberService memberService = MemberService();

            String token = await auth.currentUser!.getIdToken();
            bool createSuccess = await memberService.createMember(
                auth.currentUser!.email, auth.currentUser!.uid, token);

            if (createSuccess) {
              emit(EmailRegisteredSuccess());
            } else {
              try {
                await auth.currentUser!.delete();
              } catch (e) {
                print(e);
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
        } catch (e) {
          emit(EmailRegisteredFail(
            error: determineException(e),
          ));
        }
      },
    );
  }
}
