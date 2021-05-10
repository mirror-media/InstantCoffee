abstract class PasswordResetEmailState {}

class PasswordResetEmailInitState extends PasswordResetEmailState {}

class PasswordResetEmailSending extends PasswordResetEmailState {}

class PasswordResetEmailSendingSuccess extends PasswordResetEmailState {}

class EmailUserNotFound extends PasswordResetEmailState {}

class PasswordResetEmailSendingFail extends PasswordResetEmailState {}

class PasswordResetEmailError extends PasswordResetEmailState {
  final error;
  PasswordResetEmailError({this.error});
}
