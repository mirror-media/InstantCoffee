import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/blocs/passwordReset/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/services/emailSignInService.dart';

abstract class PasswordResetEvents{
  Stream<PasswordResetState> run(EmailSignInRepos emailSignInRepos);
}

class ConfirmPasswordReset extends PasswordResetEvents {
  final String code;
  final String newPassword;
  ConfirmPasswordReset({
    this.code, this.newPassword
  });

  @override
  String toString() => 'PasswordResetEvents';

  @override
  Stream<PasswordResetState> run(EmailSignInRepos emailSignInRepos) async*{
    print(this.toString());
    try{
      yield PasswordResetLoading();
      FirebaseAuth auth = FirebaseAuth.instance;
      bool isSuccess = await emailSignInRepos.confirmPasswordReset(auth, code, newPassword);
      if(isSuccess) {
        yield PasswordResetSuccess();
      } else {
        yield PasswordResetFail();
      }
    } on SocketException {
      yield PasswordResetError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield PasswordResetError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield PasswordResetError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield PasswordResetError(
        error: UnknownException(e.toString()),
      );
    }
  }
}