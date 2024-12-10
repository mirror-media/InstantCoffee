import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/login/login_error_widget.dart';
import 'package:readr_app/pages/login/login_form.dart';
import 'package:readr_app/pages/login/member_widget/member_widget.dart';
import 'package:readr_app/widgets/logger.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> with Logger {
  @override
  void initState() {
    _checkIsLoginOrNot();
    super.initState();
  }

  _checkIsLoginOrNot() {
    context.read<LoginBloc>().add(CheckIsLoginOrNot());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (BuildContext context, LoginState state) {
      if (state is LoadingUI) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is LoginFail) {
        final error = state.error;
        debugLog('LoginError: ${error.message}');
        return LoginErrorWidget();
      }
      if (state is LoginSuccess) {
        String israfelId = state.israfelId;
        SubscriptionType subscriptionType = state.subscriptionType;

        return MemberWidget(
          israfelId: israfelId,
          subscriptionType: subscriptionType,
          isNewebpay: state.isNewebpay,
        );
      }

      // state is Init, Third Party Loading
      return LoginForm(
        state: state,
      );
    });
  }
}
