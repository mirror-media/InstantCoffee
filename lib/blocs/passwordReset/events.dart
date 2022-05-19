abstract class PasswordResetEvents {}

class ConfirmPasswordReset extends PasswordResetEvents {
  final String code;
  final String newPassword;
  ConfirmPasswordReset({required this.code, required this.newPassword});

  @override
  String toString() => 'PasswordResetEvents';
}
