class LoginResponse<T> {
  Status status;

  T data;

  String message;
  
  LoginResponse.loadingUI(this.message) : status = Status.LoadingUI;

  LoginResponse.needToLogin(this.message) : status = Status.NeedToLogin;

  LoginResponse.facebookLoading(this.message) : status = Status.FacebookLoading;

  LoginResponse.googleLoading(this.message) : status = Status.GoogleLoading;

  LoginResponse.appleLoading(this.message) : status = Status.AppleLoading;

  LoginResponse.completed(this.data) : status = Status.Completed;

  LoginResponse.loginError(this.message) : status = Status.LoginError;

  LoginResponse.error(this.message) : status = Status.Error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status {
  LoadingUI,
  NeedToLogin,
  FacebookLoading,
  GoogleLoading,
  AppleLoading,
  Completed,
  LoginError,
  // return Error when fetching member data fail
  Error,
}
