const String registeredByGoogleMethodWarningMessage =
    '由於您曾以Google帳號登入，請點擊上方「使用 Google 登入」重試。';
const String registeredByFacebookMethodWarningMessage =
    '由於您曾以Facebook帳號登入，請點擊上方「使用 Facebook 登入」重試。';
const String registeredByAppleMethodWarningMessage =
    '由於您曾以Apple帳號登入，請點擊上方「使用 Apple 登入」重試。';
const String registeredByPasswordMethodWarningMessage =
    '由於您曾以email帳號密碼登入，請輸入下方email重試。';

abstract class LoginEvents {}

class CheckIsLoginOrNot extends LoginEvents {
  @override
  String toString() => 'CheckIsLoginOrNot';
  String eventName() => 'CheckIsLoginOrNot';
  Map eventParameters() => {};
}

class SignInWithGoogle extends LoginEvents {
  @override
  String toString() => 'SignInWithGoogle';
  String eventName() => 'SignInWithGoogle';
  Map eventParameters() => {};
}

class SignInWithFacebook extends LoginEvents {
  @override
  String toString() => 'SignInWithFacebook';
  String eventName() => 'SignInWithFacebook';
  Map eventParameters() => {};
}

class SignInWithApple extends LoginEvents {
  @override
  String toString() => 'SignInWithApple';
  String eventName() => 'SignInWithApple';
  Map eventParameters() => {};
}

class FetchSignInMethodsForEmail extends LoginEvents {
  final String email;
  FetchSignInMethodsForEmail(
    this.email,
  );

  @override
  String toString() => 'FetchSignInMethodsForEmail { "email": $email }';
  String eventName() => 'FetchSignInMethodsForEmail';
  Map eventParameters() => {'email': email};
}

class SignOut extends LoginEvents {
  @override
  String toString() => 'SignOut';
  String eventName() => 'SignOut';
  Map eventParameters() => {};
}
