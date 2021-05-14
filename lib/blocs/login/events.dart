import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/services/loginService.dart';
import 'package:readr_app/services/memberService.dart';

abstract class LoginEvents{
  Stream<LoginState> run(LoginRepos loginRepos);
  Stream<LoginState> handleCreateMember(
    BuildContext context,
    String routeName,
    Object routeArguments,
  ) async*{
    FirebaseAuth auth = FirebaseAuth.instance;
    MemberService memberService = MemberService();
    String token = await auth.currentUser.getIdToken();
    bool createSuccess = await memberService.createMember(
      auth.currentUser.email, 
      auth.currentUser.uid, 
      token
    );
    
    if(createSuccess) {
      try {
        Member member = await memberService.fetchMemberData(auth.currentUser.uid, token);

        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('登入成功')
          )
        );

        yield LoginSuccess(
          member: member,
        );
        if(routeName != RouteGenerator.member) {
          if(routeName == RouteGenerator.story) {
            Navigator.of(context).popUntil(ModalRoute.withName(RouteGenerator.root));
          } else {
            Navigator.of(context).pop();
          }
          
          Navigator.of(context).pushNamed(
            routeName,
            arguments: routeArguments,
          );
        }
      } catch(e) {
        // fetch member fail
        print(e.toString());
        LoginFail(
          error: UnknownException('Fetch member fail'),
        );
      }
    } else {
      await auth.signOut();
      LoginFail(
        error: UnknownException('Create member fail'),
      );
    }
  }
}

class CheckIsLoginOrNot extends LoginEvents {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  String toString() => 'CheckIsLoginOrNot';

  @override
  Stream<LoginState> run(LoginRepos loginRepos) async*{
    print(this.toString());
    if(_auth.currentUser == null) {
      yield LoginInitState();
    } else {
      try {
        String token = await _auth.currentUser.getIdToken();
        MemberService memberService = MemberService();
        Member member = await memberService.fetchMemberData(_auth.currentUser.uid, token);
        yield LoginSuccess(
          member: member,
        );
      } catch(e) {
        // fetch member fail
        print(e.toString());
        LoginFail(
          error: UnknownException('Fetch member fail'),
        );
      }
    }
  }
}

class SignInWithGoogle extends LoginEvents {
  final BuildContext context;
  final String routeName;
  final Object routeArguments;
  SignInWithGoogle(
    this.context,
    {
      this.routeName = RouteGenerator.magazine,
      this.routeArguments,
    }
  );
  
  @override
  String toString() => 'SignInWithGoogle';

  @override
  Stream<LoginState> run(LoginRepos loginRepos) async*{
    print(this.toString());
    try{
      yield GoogleLoading();
      FirebaseLoginStatus frebaseLoginStatus = await loginRepos.signInWithGoogle();
      if(frebaseLoginStatus.status == FirebaseStatus.Cancel) {
        yield LoginInitState();
      } else if(frebaseLoginStatus.status == FirebaseStatus.Success) {
        yield* this.handleCreateMember(context, routeName, routeArguments);
      } else if(frebaseLoginStatus.status == FirebaseStatus.Error) {
        yield LoginFail(
          error: UnknownException(frebaseLoginStatus.message),
        );
      } 
    } on SocketException {
      yield LoginFail(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield LoginFail(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield LoginFail(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield LoginFail(
        error: UnknownException(e.toString()),
      );
    }
  }
}