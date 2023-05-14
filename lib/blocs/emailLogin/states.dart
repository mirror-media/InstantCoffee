abstract class EmailLoginState {}

class EmailLoginInitState extends EmailLoginState {}

class EmailLoginLoading extends EmailLoginState {}

class EmailLoginSuccess extends EmailLoginState {}

class EmailLoginFail extends EmailLoginState {}

class EmailLoginError extends EmailLoginState {
  final dynamic error;
  EmailLoginError({this.error});
}
