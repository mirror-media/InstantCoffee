abstract class EmailVerificationState {}

class EmailVerificationInitState extends EmailVerificationState {}

class SendingEmailVerification extends EmailVerificationState {}

class SendingEmailVerificationSuccess extends EmailVerificationState {}

class SendingEmailVerificationFail extends EmailVerificationState {}

class EmailVerificationError extends EmailVerificationState {
  final error;
  EmailVerificationError({this.error});
}
