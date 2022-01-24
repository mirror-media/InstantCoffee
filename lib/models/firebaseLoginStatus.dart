class FirebaseLoginStatus {
  FirebaseStatus status;
  dynamic message;

  FirebaseLoginStatus({
    required this.status,
    this.message,
  });
}

enum FirebaseStatus {
  Cancel,
  Success,
  Error, 
}