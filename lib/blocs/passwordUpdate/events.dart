abstract class PasswordUpdateEvents {}

class ConfirmOldPassword extends PasswordUpdateEvents {
  final String oldPassword;
  ConfirmOldPassword({required this.oldPassword});

  @override
  String toString() => 'ConfirmOldPassword';
}

class UpdatePassword extends PasswordUpdateEvents {
  final String newPassword;
  UpdatePassword({required this.newPassword});

  @override
  String toString() => 'UpdatePassword';
}
