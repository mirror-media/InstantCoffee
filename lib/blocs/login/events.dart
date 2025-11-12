const String registeredByThirdPartyMethodWarningMessage =
    '此信箱已使用第三方登入，請使用其他登入方式重試。';
const String registeredByPasswordMethodWarningMessage =
    '此信箱已使用 email 密碼登入，請改用密碼登入。';

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

class CheckEmailSignInMethod extends LoginEvents {
  final String email;
  CheckEmailSignInMethod(
    this.email,
  );

  @override
  String toString() => 'CheckEmailSignInMethod { "email": $email }';
  String eventName() => 'CheckEmailSignInMethod';
  Map eventParameters() => {'email': email};
}

class SignOut extends LoginEvents {
  @override
  String toString() => 'SignOut';
  String eventName() => 'SignOut';
  Map eventParameters() => {};
}
