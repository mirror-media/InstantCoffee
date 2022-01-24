import 'dart:io';

import 'package:readr_app/blocs/emailLogin/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';


abstract class EmailLoginEvents{
  Stream<EmailLoginState> run(EmailSignInRepos emailSignInRepos);
}

class SignInWithEmailAndPassword extends EmailLoginEvents {
  final String email;
  final String password;
  SignInWithEmailAndPassword({
    required this.email, 
    required this.password,
  });

  @override
  String toString() => 'SignInWithEmailAndPassword { email: $email, password: ****** }';

  @override
  Stream<EmailLoginState> run(EmailSignInRepos emailSignInRepos) async*{
    print(this.toString());
    try{
      yield EmailLoginLoading();
      FirebaseLoginStatus frebaseLoginStatus = await emailSignInRepos.signInWithEmailAndPassword(email, password);
      if(frebaseLoginStatus.status == FirebaseStatus.Success) {
        yield EmailLoginSuccess();
      } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
        if(frebaseLoginStatus.message == 'wrong-password') {
          yield EmailLoginFail();
        } else {
          yield EmailLoginError(
            error: UnknownException(frebaseLoginStatus.message),
          );
        }
      } 
    } on SocketException {
      yield EmailLoginError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield EmailLoginError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield EmailLoginError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield EmailLoginError(
        error: UnknownException(e.toString()),
      );
    }
  }
}