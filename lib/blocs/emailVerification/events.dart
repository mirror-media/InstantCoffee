abstract class EmailVerificationEvents {}

class SendEmailVerification extends EmailVerificationEvents {
  final String email;
  final String redirectUrl;
  SendEmailVerification({
    required this.email,
    required this.redirectUrl,
  });

  @override
  String toString() =>
      'SendEmailVerification { email: $email, redirectUrl: $redirectUrl }';
}
