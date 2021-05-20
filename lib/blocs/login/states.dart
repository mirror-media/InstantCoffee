import 'package:readr_app/models/member.dart';

abstract class LoginState {}

class LoadingUI extends LoginState {}

class LoginInitState extends LoginState {}

class LoginSuccess extends LoginState {
  final Member member;
  LoginSuccess({this.member});
}

class GoogleLoading extends LoginState {}

class FacebookLoading extends LoginState {}

class LoginFail extends LoginState {
  final error;
  LoginFail({this.error});
}