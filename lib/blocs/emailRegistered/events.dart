abstract class EmailRegisteredEvents {}

class CreateUserWithEmailAndPassword extends EmailRegisteredEvents {
  final String email;
  final String password;
  CreateUserWithEmailAndPassword({
    required this.email,
    required this.password,
  });

  @override
  String toString() =>
      'CreateUserWithEmailAndPassword { email: $email, password: ****** }';
}
