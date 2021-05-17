import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailLogin/events.dart';
import 'package:readr_app/blocs/emailLogin/states.dart';
import 'package:readr_app/services/emailSignInService.dart';

class EmailLoginBloc extends Bloc<EmailLoginEvents, EmailLoginState> {
  final EmailSignInRepos emailSignInRepos;

  EmailLoginBloc({this.emailSignInRepos}) : super(EmailLoginInitState());

  @override
  Stream<EmailLoginState> mapEventToState(EmailLoginEvents event) async* {
    yield* event.run(emailSignInRepos);
  }
}
