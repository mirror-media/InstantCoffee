abstract class PasswordUpdateState {}
class OldPasswordConfirm extends PasswordUpdateState{}

class OldPasswordConfirmInitState extends OldPasswordConfirm {}

class OldPasswordConfirmLoading extends OldPasswordConfirm {}

class OldPasswordConfirmFail extends OldPasswordConfirm {}

class PasswordUpdateInitState extends PasswordUpdateState {}

class PasswordUpdateError extends PasswordUpdateState {
  final error;
  PasswordUpdateError({this.error});
}
