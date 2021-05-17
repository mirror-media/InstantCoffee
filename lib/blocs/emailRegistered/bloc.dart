import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/emailRegistered/events.dart';
import 'package:readr_app/blocs/emailRegistered/states.dart';
import 'package:readr_app/services/emailSignInService.dart';

class EmailRegisteredBloc extends Bloc<EmailRegisteredEvents, EmailRegisteredState> {
  final EmailSignInRepos emailSignInRepos;

  EmailRegisteredBloc({this.emailSignInRepos}) : super(EmailRegisteredInitState());

  @override
  Stream<EmailRegisteredState> mapEventToState(EmailRegisteredEvents event) async* {
    yield* event.run(emailSignInRepos);
  }
}
