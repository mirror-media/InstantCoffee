import 'dart:io';

import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/blocs/emailVerification/states.dart';


abstract class EmailVerificationEvents{
  Stream<EmailVerificationState> run(EmailSignInRepos emailSignInRepos);
}

class SendEmailVerification extends EmailVerificationEvents {
  final String email;
  final String redirectUrl;
  SendEmailVerification({
    this.email, 
    this.redirectUrl,
  });

  @override
  String toString() => 'SendEmailVerification { email: $email, redirectUrl: $redirectUrl }';

  @override
  Stream<EmailVerificationState> run(EmailSignInRepos emailSignInRepos) async*{
    print(this.toString());
    try{
      yield SendingEmailVerification();
      FirebaseLoginStatus firebaseLoginStatus = await emailSignInRepos.sendEmailVerification(
        email,
        redirectUrl,
      );
      if(firebaseLoginStatus.status == FirebaseStatus.Success) {
        yield SendingEmailVerificationSuccess();
      } else if(firebaseLoginStatus.status == FirebaseStatus.Error) {
        yield SendingEmailVerificationFail();
      }
    } on SocketException {
      yield EmailVerificationError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield EmailVerificationError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield EmailVerificationError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield EmailVerificationError(
        error: UnknownException(e.toString()),
      );
    }
  }
}