class FirebaseLoginStatus {
  FirebaseStatus status;
  dynamic message;

  FirebaseLoginStatus({
    this.status,
    this.message,
  });
}

enum FirebaseStatus {
  Cancel,
  Success,
  Error, 
}