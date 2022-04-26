import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/helpers/appUpgradeHelper.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/firebaseLoginStatus.dart';
import 'package:readr_app/pages/emailVerification/emailVerificationSuccessPage.dart';
import 'package:readr_app/pages/appUpdatePage.dart';
import 'package:readr_app/pages/onBoardingPage.dart';
import 'package:readr_app/services/emailSignInService.dart';

class InitialApp extends StatefulWidget {
  @override
  _InitialAppState createState() => _InitialAppState();
}

class _InitialAppState extends State<InitialApp> {
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  AppUpgradeHelper _appUpgradeHelper = AppUpgradeHelper();
  StreamController<bool> _configController = StreamController<bool>();
  
  // It cant trigger on iOS, cuz AppsFlyer's code on AppDelegate.swift break this feature.
  // The iOS DynamicLinks method will implement in initialAppsFlyer function.
  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async{ 
        final Uri deepLink = dynamicLink.link;

        if (deepLink.path == '/__/auth/action') {
          if(deepLink.queryParameters['mode'] == 'resetPassword') {
            Navigator.of(context).popUntil((route) => route.isFirst);
            RouteGenerator.navigateToPasswordReset(
              code: deepLink.queryParameters['oobCode']!,
            );
          } else if(deepLink.queryParameters['mode'] == 'verifyEmail') {
            Navigator.of(context).popUntil((route) => route.isFirst);
            String continueUrl = deepLink.queryParameters['continueUrl']!;
            String email = continueUrl.split('?email=')[1];
            String code = deepLink.queryParameters['oobCode']!;
            EmailSignInServices emailSignInServices = EmailSignInServices();
            FirebaseLoginStatus firebaseLoginStatus = await emailSignInServices.applyActionCode(code);
            
            if(firebaseLoginStatus.status == FirebaseStatus.Success){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailVerificationSuccessPage(
                    email: email,
                  )
                )
              );
            }else {
              Fluttertoast.showToast(
                msg: 'email驗證失敗',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
              );
            }
          }
        }
      }
    ).onError((e) {
      print('onLinkError');
      print(e.message);
    });
    
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null && 
      deepLink.path == '/__/auth/action') {
      if(deepLink.queryParameters['mode'] == 'resetPassword') {
        RouteGenerator.navigateToPasswordReset(
          code: deepLink.queryParameters['oobCode']!,
        );
      } else if(deepLink.queryParameters['mode'] == 'verifyEmail') {
        Navigator.of(context).popUntil((route) => route.isFirst);
        String continueUrl = deepLink.queryParameters['continueUrl']!;
        String email = continueUrl.split('?email=')[1];
        String code = deepLink.queryParameters['oobCode']!;
        EmailSignInServices emailSignInServices = EmailSignInServices();
        FirebaseLoginStatus firebaseLoginStatus = await emailSignInServices.applyActionCode(code);
        
        if(firebaseLoginStatus.status == FirebaseStatus.Success){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerificationSuccessPage(
                email: email,
              )
            )
          );
        }else {
          Fluttertoast.showToast(
            msg: 'email驗證失敗',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
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
  
  _waiting() async{
    await _remoteConfigHelper.initialize();
    _appUpgradeHelper.needToUpdate = await _appUpgradeHelper.isUpdateAvailable();
    print('in-app upgrade: ${_appUpgradeHelper.needToUpdate}');

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
        if(!snapshot.data!) {
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
                  SizedBox(height: 16),
                  Text('Loading...'),
                ]
              ),
            ),
          );
        }

        if(_appUpgradeHelper.needToUpdate) {
          return AppUpdatePage(appUpgradeHelper: _appUpgradeHelper);
        }

        _fetchMemberSubscriptionType();
        return _buildPage();
      }
    );
  }

  Widget _buildPage() {
    return BlocConsumer<MemberBloc, MemberState>(
      listener: (BuildContext context, MemberState state) {
        MemberStatus status = state.status;
        print(status);
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
                    SizedBox(height: 16),
                    Text('Loading...'),
                  ]
                ),
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
              child: OnBoardingPage(isPremium: false),
            );
        }
      },
    );
  }
}