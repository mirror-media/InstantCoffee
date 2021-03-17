class LoginResponse<T> {
  Status status;

  T data;

  String message;
  
  LoginResponse.loadingUI(this.message) : status = Status.LoadingUI;

  LoginResponse.needToLogin(this.message) : status = Status.NeedToLogin;

  LoginResponse.facebookLoading(this.message) : status = Status.FacebookLoading;

  LoginResponse.googleLoading(this.message) : status = Status.GoogleLoading;

  LoginResponse.appleLoading(this.message) : status = Status.AppleLoading;

  LoginResponse.emailLoading(this.message) : status = Status.EmailLoading;

  LoginResponse.emailLinkGetting(this.data) : status = Status.EmailLinkGetting;

  LoginResponse.verifyEmailLoading(this.message) : status = Status.VerifyEmailLoading;

  LoginResponse.emailFillingIn(this.message) : status = Status.EmailFillingIn;

  LoginResponse.completed(this.data) : status = Status.Completed;

  LoginResponse.emailVerifyError(this.message) : status = Status.EmailVerifyError;

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
  EmailLoading,
  EmailLinkGetting,
  VerifyEmailLoading,
  EmailFillingIn,
  Completed,
  EmailVerifyError,
  LoginError,
  // return Error when fetching member data fail
  Error,
}
