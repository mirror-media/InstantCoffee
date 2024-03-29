abstract class PasswordUpdateState {}

class OldPasswordConfirm extends PasswordUpdateState {}

class OldPasswordConfirmInitState extends OldPasswordConfirm {}

class OldPasswordConfirmLoading extends OldPasswordConfirm {}

class OldPasswordConfirmFail extends OldPasswordConfirm {}

class PasswordUpdateInitState extends PasswordUpdateState {}

class PasswordUpdateLoading extends PasswordUpdateState {}

class PasswordUpdateSuccess extends PasswordUpdateState {}

class PasswordUpdateError extends PasswordUpdateState {
  final dynamic error;
  PasswordUpdateError({this.error});
}
