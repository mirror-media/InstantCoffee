import 'dart:io';

import 'package:readr_app/blocs/passwordResetEmail/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';


abstract class PasswordResetEmailEvents{
  Stream<PasswordResetEmailState> run(EmailSignInRepos emailSignInRepos);
}

class SendPasswordResetEmail extends PasswordResetEmailEvents {
  final String email;
  SendPasswordResetEmail({
    this.email, 
  });

  @override
  String toString() => 'SendPasswordResetEmail { email: $email}';

  @override
  Stream<PasswordResetEmailState> run(EmailSignInRepos emailSignInRepos) async*{
    print(this.toString());
    try{
      yield PasswordResetEmailSending();
      FirebaseLoginStatus firebaseLoginStatus = await emailSignInRepos.sendPasswordResetEmail(email);
      if(firebaseLoginStatus.status == FirebaseStatus.Success) {
        yield PasswordResetEmailSendingSuccess();
      } else if(firebaseLoginStatus.status == FirebaseStatus.Error) {
        if(firebaseLoginStatus.message == 'user-not-found') {
          yield EmailUserNotFound();
        } else {
          yield PasswordResetEmailSendingFail();
        }
      }
    } on SocketException {
      yield PasswordResetEmailError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield PasswordResetEmailError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield PasswordResetEmailError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield PasswordResetEmailError(
        error: UnknownException(e.toString()),
      );
    }
  }
}