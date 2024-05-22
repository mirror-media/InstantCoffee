import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/helpers/app_upgrade_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/firebase_login_status.dart';
import 'package:readr_app/pages/emailVerification/email_verification_success_page.dart';
import 'package:readr_app/pages/app_update_page.dart';
import 'package:readr_app/pages/on_boarding_page.dart';
import 'package:readr_app/services/email_sign_in_service.dart';
import 'package:readr_app/widgets/logger.dart';

class InitialApp extends StatefulWidget {
  @override
  _InitialAppState createState() => _InitialAppState();
}

class _InitialAppState extends State<InitialApp> with Logger {
  final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  final AppUpgradeHelper _appUpgradeHelper = AppUpgradeHelper();
  final StreamController<bool> _configController = StreamController<bool>();
  final String _deepLinkPath = '/email-handler';

  // It cant trigger on iOS, cuz AppsFlyer's code on AppDelegate.swift break this feature.
  // The iOS DynamicLinks method will implement in initialAppsFlyer function.
  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink.link;

      if (deepLink.path == _deepLinkPath) {
        if (deepLink.queryParameters['mode'] == 'resetPassword') {
          Navigator.of(context).popUntil((route) => route.isFirst);
          RouteGenerator.navigateToPasswordReset(
            code: deepLink.queryParameters['oobCode']!,
          );
        } else if (deepLink.queryParameters['mode'] == 'verifyEmail') {
          Navigator.of(context).popUntil((route) => route.isFirst);
          String continueUrl = deepLink.queryParameters['continueUrl']!;
          String email = continueUrl.split('?email=')[1];
          String code = deepLink.queryParameters['oobCode']!;
          EmailSignInServices emailSignInServices = EmailSignInServices();
          FirebaseLoginStatus firebaseLoginStatus =
              await emailSignInServices.applyActionCode(code);

          if (firebaseLoginStatus.status == FirebaseStatus.Success) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmailVerificationSuccessPage(
                          email: email,
                        )));
          } else {
            Fluttertoast.showToast(
                msg: 'email驗證失敗',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      }
    }).onError((e) {
      debugLog('onLinkError');
      debugLog(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null && deepLink.path == _deepLinkPath) {
      if (deepLink.queryParameters['mode'] == 'resetPassword') {
        RouteGenerator.navigateToPasswordReset(
          code: deepLink.queryParameters['oobCode']!,
        );
      } else if (deepLink.queryParameters['mode'] == 'verifyEmail') {
        Navigator.of(context).popUntil((route) => route.isFirst);
        String continueUrl = deepLink.queryParameters['continueUrl']!;
        String email = continueUrl.split('?email=')[1];
        String code = deepLink.queryParameters['oobCode']!;
        EmailSignInServices emailSignInServices = EmailSignInServices();
        FirebaseLoginStatus firebaseLoginStatus =
            await emailSignInServices.applyActionCode(code);

        if (firebaseLoginStatus.status == FirebaseStatus.Success) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmailVerificationSuccessPage(
                        email: email,
                      )));
        } else {
          Fluttertoast.showToast(
              msg: 'email驗證失敗',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }

  void _fetchMemberSubscriptionType() {
    context.read<MemberBloc>().add(FetchMemberSubscriptionType());
  }

  @override
  void initState() {
    _waiting();
    super.initState();
  }

  _waiting() async {
    await _remoteConfigHelper.initialize();
    _appUpgradeHelper.needToUpdate =
        await _appUpgradeHelper.isUpdateAvailable();
    debugLog('in-app upgrade: ${_appUpgradeHelper.needToUpdate}');

    await initDynamicLinks();
    _configController.sink.add(true);
  }

  @override
  void dispose() {
    _configController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: _configController.stream,
        builder: (context, snapshot) {
          if (!snapshot.data!) {
            return Scaffold(
              backgroundColor: appColor,
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        splashIconPng,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      const Text('Loading...'),
                    ]),
              ),
            );
          }

          if (_appUpgradeHelper.needToUpdate) {
            return AppUpdatePage(appUpgradeHelper: _appUpgradeHelper);
          }

          _fetchMemberSubscriptionType();
          return _buildPage();
        });
  }

  Widget _buildPage() {
    return BlocConsumer<MemberBloc, MemberState>(
      listener: (BuildContext context, MemberState state) {
        MemberStatus status = state.status;
        debugLog(status);
      },
      builder: (BuildContext context, MemberState state) {
        MemberStatus status = state.status;
        switch (status) {
          case MemberStatus.loading:
            return Scaffold(
              backgroundColor: appColor,
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        splashIconPng,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      const Text('Loading...'),
                    ]),
              ),
            );
          case MemberStatus.loaded:
            bool isPremium = state.isPremium;

            return BlocProvider(
              create: (context) => OnBoardingBloc(),
              child: OnBoardingPage(isPremium: isPremium),
            );
          case MemberStatus.error:
            return BlocProvider(
              create: (context) => OnBoardingBloc(),
              child: const OnBoardingPage(isPremium: false),
            );
        }
      },
    );
  }
}
