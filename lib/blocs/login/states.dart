import 'package:readr_app/models/member_subscription_type.dart';

abstract class LoginState {}

class LoadingUI extends LoginState {}

class LoginInitState extends LoginState {}

class LoginSuccess extends LoginState {
  final String israfelId;
  final SubscriptionType subscriptionType;
  final bool isNewebpay;

  LoginSuccess({
    required this.israfelId,
    required this.subscriptionType,
    required this.isNewebpay,
  });
}

enum LoginType { google, facebook, apple, anonymous, email }

class LoginLoading extends LoginState {
  final LoginType loginType;

  LoginLoading({
    required this.loginType,
  });
}

class FetchSignInMethodsForEmailLoading extends LoginState {}

class RegisteredByAnotherMethod extends LoginInitState {
  final String warningMessage;

  RegisteredByAnotherMethod({required this.warningMessage});
}

class LoginFail extends LoginState {
  final dynamic error;

  LoginFail({this.error});
}
