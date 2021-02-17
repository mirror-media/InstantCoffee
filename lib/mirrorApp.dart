import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/helpers/appUpgradeHelper.dart';
import 'package:readr_app/helpers/appsFlyerHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/pages/homePage.dart';

class MirrorApp extends StatefulWidget {
  @override
  _MirrorAppState createState() => _MirrorAppState();
}

class _MirrorAppState extends State<MirrorApp> {
  AppsFlyerHelper _appsFlyerHelper;
  
  GlobalKey _settingKey;
  AppUpgradeHelper _appUpgradeHelper;
  StreamController _configController;
  OnBoardingBloc _onBoardingBloc;

  bool _isUpdateAvailable = false;

  @override
  void initState() {
    _appsFlyerHelper = AppsFlyerHelper();

    _settingKey = GlobalKey();
    _appUpgradeHelper = AppUpgradeHelper();
    _configController = StreamController<bool>();
    _onBoardingBloc = OnBoardingBloc();
    _waiting();
    super.initState();
  }

  // It cant trigger on iOS, cuz AppsFlyer's code on AppDelegate.swift break this feature.
  // The iOS DynamicLinks method will implement in initialAppsFlyer function.
  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null && deepLink.path == '/__/auth/action') {
          Navigator.of(context).popUntil((route) => route.isFirst);
          RouteGenerator.navigateToMember(
            context, 
            isEmailLoginAuth: true,
            emailLink: deepLink.toString(),
          );
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
    
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null && deepLink.path == '/__/auth/action') {
      RouteGenerator.navigateToMember(
        context, 
        isEmailLoginAuth: true,
        emailLink: deepLink.toString(),
      );
    }
  }
  
  _waiting() async{
    _isUpdateAvailable = await _appUpgradeHelper.isUpdateAvailable();
    print('in-app upgrade: $_isUpdateAvailable');

    _onBoardingBloc.setOnBoardingHintList();
    await _onBoardingBloc.setOnBoardingFromStorage();

    await _appsFlyerHelper.initialAppsFlyer(context);
    await initDynamicLinks();
    _configController.sink.add(true);
  }

  @override
  void dispose() {
    _configController.close();
    _onBoardingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<bool>(
      initialData: false,
      stream: _configController.stream,
      builder: (context, snapshot) {
        if(!snapshot.data) {
          return Scaffold(body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Loading...'),
              SizedBox(height: 16),
              Center(child: CircularProgressIndicator()),
            ],
          ));
        }

        return StreamBuilder<OnBoarding>(
          initialData: OnBoarding(isOnBoarding: false),
          stream: _onBoardingBloc.onBoardingStream,
          builder: (context, snapshot) {
            OnBoarding onBoarding = snapshot.data;
            return Material(
              type: MaterialType.transparency,
              child: Stack(
                children: [
                  HomePage(
                    settingKey: _settingKey,
                    onBoardingBloc: _onBoardingBloc,
                    isUpdateAvailable: _isUpdateAvailable,
                  ),
                  if(onBoarding.isOnBoarding && 
                  !onBoarding.isNeedInkWell)
                    _onBoardingBloc.getClipPathOverlay(
                      onBoarding.left,
                      onBoarding.top,
                      onBoarding.width,
                      onBoarding.height,
                    ),
                  if(onBoarding.isOnBoarding && 
                  onBoarding.isNeedInkWell)
                    GestureDetector(
                      onTap: () async{
                        if(_onBoardingBloc.isOnBoarding && 
                        _onBoardingBloc.status == OnBoardingStatus.ThirdPage) {
                          OnBoarding onBoarding = await _onBoardingBloc.getSizeAndPosition(_settingKey);
                          onBoarding.isNeedInkWell = true;

                          _onBoardingBloc.checkOnBoarding(onBoarding);
                          _onBoardingBloc.status = OnBoardingStatus.FourthPage;
                          onBoarding.function = () {
                            RouteGenerator.navigateToNotificationSettings(
                              context, 
                              _onBoardingBloc
                            );
                          };
                        } else {
                          onBoarding.function?.call();
                        }
                      },
                      child: _onBoardingBloc.getCustomPaintOverlay(
                        context,
                        onBoarding.left,
                        onBoarding.top,
                        onBoarding.width,
                        onBoarding.height,
                      ),
                    ),
                  if(onBoarding.isOnBoarding)
                    _onBoardingBloc.getHint(
                      context,
                      onBoarding.left, 
                      onBoarding.top + onBoarding.height,
                      _onBoardingBloc.onBoardingHintList[_onBoardingBloc.status.index-1],
                    ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}