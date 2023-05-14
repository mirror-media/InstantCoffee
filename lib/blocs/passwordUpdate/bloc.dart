import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/passwordUpdate/events.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/helpers/error_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/services/email_sign_in_service.dart';
import 'package:readr_app/widgets/logger.dart';

class PasswordUpdateBloc extends Bloc<PasswordUpdateEvents, PasswordUpdateState>
    with Logger {
  final EmailSignInRepos emailSignInRepos;
  PasswordUpdateBloc({required this.emailSignInRepos})
      : super(OldPasswordConfirmInitState()) {
    on<PasswordUpdateEvents>(
      (event, emit) async {
        debugLog(event.toString());
        try {
          if (event is ConfirmOldPassword) {
            emit(OldPasswordConfirmLoading());
            bool isSuccess =
                await emailSignInRepos.confirmOldPassword(event.oldPassword);
            if (isSuccess) {
              // go to update password
              emit(PasswordUpdateInitState());
            } else {
              emit(OldPasswordConfirmFail());
            }
          }

          if (event is UpdatePassword) {
            emit(PasswordUpdateLoading());
            bool isSuccess =
                await emailSignInRepos.updatePassword(event.newPassword);
            if (isSuccess) {
              emit(PasswordUpdateSuccess());
            } else {
              Fluttertoast.showToast(
                  msg: '更改密碼失敗',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              RouteGenerator.navigatorKey.currentState!.pop();
            }
          }
        } catch (e) {
          emit(PasswordUpdateError(
            error: determineException(e),
          ));
        }
      },
    );
  }
}
