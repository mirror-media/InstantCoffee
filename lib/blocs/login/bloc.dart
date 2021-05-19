import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/services/loginService.dart';

class LoginBloc extends Bloc<LoginEvents, LoginState> {
  final LoginRepos loginRepos;
  final String routeName;
  final Object routeArguments;

  LoginBloc({
    this.loginRepos,
    this.routeName,
    this.routeArguments,
  }) : super(LoadingUI());

  @override
  Stream<LoginState> mapEventToState(LoginEvents event) async* {
    yield* event.run(
      loginRepos,
      routeName,
      routeArguments,
    );
  }
}
