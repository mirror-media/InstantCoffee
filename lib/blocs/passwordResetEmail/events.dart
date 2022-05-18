abstract class PasswordResetEmailEvents {}

class SendPasswordResetEmail extends PasswordResetEmailEvents {
  final String email;
  SendPasswordResetEmail({
    required this.email,
  });

  @override
  String toString() => 'SendPasswordResetEmail { email: $email}';
}
