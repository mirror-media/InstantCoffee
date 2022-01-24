import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/events.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/services/emailSignInService.dart';

class PasswordUpdateBloc extends Bloc<PasswordUpdateEvents, PasswordUpdateState> {
  final EmailSignInRepos emailSignInRepos;
  PasswordUpdateBloc({required this.emailSignInRepos}) : super(OldPasswordConfirmInitState());

  @override
  Stream<PasswordUpdateState> mapEventToState(PasswordUpdateEvents event) async* {
    yield* event.run(emailSignInRepos);
  }
}
