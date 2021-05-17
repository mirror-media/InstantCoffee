import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordReset/events.dart';
import 'package:readr_app/blocs/passwordReset/states.dart';
import 'package:readr_app/services/emailSignInService.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvents, PasswordResetState> {
  final EmailSignInRepos emailSignInRepos;

  PasswordResetBloc({this.emailSignInRepos}) : super(PasswordResetInitState());

  @override
  Stream<PasswordResetState> mapEventToState(PasswordResetEvents event) async* {
    yield* event.run(emailSignInRepos);
  }
}
