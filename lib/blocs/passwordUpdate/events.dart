import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/helpers/exceptions.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/services/emailSignInService.dart';

abstract class PasswordUpdateEvents{
  Stream<PasswordUpdateState> run(EmailSignInRepos emailSignInRepos);
}

class ConfirmOldPassword extends PasswordUpdateEvents {
  final String oldPassword;
  ConfirmOldPassword({
    required this.oldPassword
  });

  @override
  String toString() => 'ConfirmOldPassword';

  @override
  Stream<PasswordUpdateState> run(EmailSignInRepos emailSignInRepos) async*{
    print(this.toString());
    try{
      yield OldPasswordConfirmLoading();
      bool isSuccess = await emailSignInRepos.confirmOldPassword(oldPassword);
      if(isSuccess) {
        // go to update password
        yield PasswordUpdateInitState();
      } else {
        yield OldPasswordConfirmFail();
      }
    } on SocketException {
      yield PasswordUpdateError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield PasswordUpdateError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield PasswordUpdateError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield PasswordUpdateError(
        error: UnknownException(e.toString()),
      );
    }
  }
}

class UpdatePassword extends PasswordUpdateEvents {
  final String newPassword;
  UpdatePassword({
    required this.newPassword
  });

  @override
  String toString() => 'UpdatePassword';

  @override
  Stream<PasswordUpdateState> run(EmailSignInRepos emailSignInRepos) async*{
    print(this.toString());
    try{
      yield PasswordUpdateLoading();
      bool isSuccess = await emailSignInRepos.updatePassword(newPassword);
      if(isSuccess) {
        yield PasswordUpdateSuccess();
      } else {
        Fluttertoast.showToast(
          msg: '更改密碼失敗',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
        
        RouteGenerator.navigatorKey.currentState!.pop();
      }
    } on SocketException {
      yield PasswordUpdateError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield PasswordUpdateError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield PasswordUpdateError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      yield PasswordUpdateError(
        error: UnknownException(e.toString()),
      );
    }
  }
}