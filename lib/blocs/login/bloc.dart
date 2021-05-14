import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/services/loginService.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  final LoginRepos loginRepos;

  LoginBloc({this.loginRepos}) : super(LoadingUI());

  @override
  Stream<LoginState> mapEventToState(LoginEvents event) async* {
    yield* event.run(loginRepos);
  }
}
