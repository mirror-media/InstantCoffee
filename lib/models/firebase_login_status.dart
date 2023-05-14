class FirebaseLoginStatus {
  FirebaseStatus status;
  dynamic message;

  FirebaseLoginStatus({
    required this.status,
    this.message,
  });
}

enum FirebaseStatus {
  Cancel, // ignore: constant_identifier_names
  Success, // ignore: constant_identifier_names
  Error, // ignore: constant_identifier_names
}
