class FirebaseLoginStatus {
  FirebaseStatus status;
  String message;

  FirebaseLoginStatus({
    this.status,
    this.message,
  });
}

enum FirebaseStatus {
  Cancel,
  Success,
  EmailVerifyError,
  Error, 
}