final String registeredByGoogleMethodWarningMessage = '由於您曾以Google帳號登入，請點擊上方「使用 Google 登入」重試。';
final String registeredByFacebookMethodWarningMessage = '由於您曾以Facebook帳號登入，請點擊上方「使用 Facebook 登入」重試。';
final String registeredByAppleMethodWarningMessage = '由於您曾以Apple帳號登入，請點擊上方「使用 Apple 登入」重試。';
final String registeredByPasswordMethodWarningMessage = '由於您曾以email帳號密碼登入，請輸入下方email重試。';

abstract class LoginEvents{}

class CheckIsLoginOrNot extends LoginEvents {
  @override
  String toString() => 'CheckIsLoginOrNot';
}

class SignInWithGoogle extends LoginEvents {
  @override
  String toString() => 'SignInWithGoogle';
}

class SignInWithFacebook extends LoginEvents {
  @override
  String toString() => 'SignInWithFacebook';
}

class SignInWithApple extends LoginEvents {
  @override
  String toString() => 'SignInWithApple';
}

class FetchSignInMethodsForEmail extends LoginEvents {
  final String email;
  FetchSignInMethodsForEmail(
    this.email,
  );
  
  @override
  String toString() => 'FetchSignInMethodsForEmail';
}

class SignOut extends LoginEvents {
  @override
  String toString() => 'SignOut';
}