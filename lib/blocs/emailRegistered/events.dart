import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:readr_app/blocs/emailRegistered/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/services/memberService.dart';

abstract class EmailRegisteredEvents{
  Stream<EmailRegisteredState> run(EmailSignInRepos emailSignInRepos);
}

class CreateUserWithEmailAndPassword extends EmailRegisteredEvents {
  final String email;
  final String password;
  CreateUserWithEmailAndPassword({
    this.email, 
    this.password,
  });

  @override
  String toString() => 'CreateUserWithEmailAndPassword { email: $email, password: ****** }';

  @override
  Stream<EmailRegisteredState> run(EmailSignInRepos emailSignInRepos) async*{
    print(this.toString());
    try{
      yield EmailRegisteredLoading();
      FirebaseLoginStatus frebaseLoginStatus = await emailSignInRepos.createUserWithEmailAndPassword(email, password);
      if(frebaseLoginStatus.status == FirebaseStatus.Success) {
        FirebaseAuth auth = FirebaseAuth.instance;
        MemberService memberService = MemberService();
        
        String token = await auth.currentUser.getIdToken();
        bool createSuccess = await memberService.createMember(
          auth.currentUser.email, 
          auth.currentUser.uid, 
          token
        );
        
        if(createSuccess) {
          yield EmailRegisteredSuccess();
        } else {
          await auth.signOut();
          yield EmailRegisteredFail(
            error: UnknownException('Create member fail'),
          );
        }
      } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
        if(frebaseLoginStatus.message == 'email-already-in-use') {
          yield EmailAlreadyInUse();
        } else {
          yield EmailRegisteredFail(
            error: UnknownException(frebaseLoginStatus.message),
          );
        }
      } 
    } on SocketException {
      yield EmailRegisteredFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield EmailRegisteredFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield EmailRegisteredFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield EmailRegisteredFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}