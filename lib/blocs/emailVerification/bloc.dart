import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailVerification/events.dart';
import 'package:readr_app/blocs/emailVerification/states.dart';
import 'package:readr_app/services/emailSignInService.dart';

class EmailVerificationBloc extends Bloc<EmailVerificationEvents, EmailVerificationState> {
  final EmailSignInRepos emailSignInRepos;

  EmailVerificationBloc({this.emailSignInRepos}) : super(EmailVerificationInitState());

  @override
  Stream<EmailVerificationState> mapEventToState(EmailVerificationEvents event) async* {
    yield* event.run(emailSignInRepos);
  }
}
