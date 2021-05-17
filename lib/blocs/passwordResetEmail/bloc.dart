import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordResetEmail/events.dart';
import 'package:readr_app/blocs/passwordResetEmail/states.dart';
import 'package:readr_app/services/emailSignInService.dart';

class PasswordResetEmailBloc extends Bloc<PasswordResetEmailEvents, PasswordResetEmailState> {
  final EmailSignInRepos emailSignInRepos;

  PasswordResetEmailBloc({this.emailSignInRepos}) : super(PasswordResetEmailInitState());

  @override
  Stream<PasswordResetEmailState> mapEventToState(PasswordResetEmailEvents event) async* {
    yield* event.run(emailSignInRepos);
  }
}
