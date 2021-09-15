import 'package:readr_app/models/memberSubscriptionType.dart';

abstract class LoginState {}

class LoadingUI extends LoginState {}

class LoginInitState extends LoginState {}

class LoginSuccess extends LoginState {
  final String israfelId;
  final SubscritionType subscritionType;
  LoginSuccess({
    this.israfelId,
    this.subscritionType
  });
}

class GoogleLoading extends LoginState {}

class FacebookLoading extends LoginState {}

class AppleLoading extends LoginState {}

class FetchSignInMethodsForEmailLoading extends LoginState {}

class RegisteredByAnotherMethod extends LoginInitState {
  final String warningMessage;
  RegisteredByAnotherMethod({this.warningMessage});
}

class LoginFail extends LoginState {
  final error;
  LoginFail({this.error});
}