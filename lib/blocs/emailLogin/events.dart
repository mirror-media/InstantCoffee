abstract class EmailLoginEvents {}

class SignInWithEmailAndPassword extends EmailLoginEvents {
  final String email;
  final String password;
  SignInWithEmailAndPassword({
    required this.email,
    required this.password,
  });

  @override
  String toString() =>
      'SignInWithEmailAndPassword { email: $email, password: ****** }';
}
