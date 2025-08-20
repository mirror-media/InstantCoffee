import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/helpers/app_upgrade_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/pages/app_update_page.dart';
import 'package:readr_app/pages/on_boarding_page.dart';
import 'package:readr_app/services/comscore_service.dart';
import 'package:readr_app/widgets/logger.dart';

class InitialApp extends StatefulWidget {
  const InitialApp({Key? key}) : super(key: key);

  @override
  InitialAppState createState() => InitialAppState();
}

class InitialAppState extends State<InitialApp> with Logger {
  final RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  final AppUpgradeHelper _appUpgradeHelper = AppUpgradeHelper();
  final StreamController<bool> _configController = StreamController<bool>();

  void _fetchMemberSubscriptionType() {
    context.read<MemberBloc>().add(FetchMemberSubscriptionType());
  }

  @override
  void initState() {
    _waiting();
    super.initState();
  }

  _waiting() async {
    try {
      await _remoteConfigHelper.initialize();
    } catch (e) {
      debugLog('Remote Config initialization failed: $e');
    }

    // Initialize Comscore Analytics
    try {
      await ComscoreService.instance.initialize();
    } catch (e) {
      debugLog('Comscore initialization failed: $e');
    }

    try {
      _appUpgradeHelper.needToUpdate =
          await _appUpgradeHelper.isUpdateAvailable();
    } catch (e) {
      debugLog('App upgrade check failed: $e');
      _appUpgradeHelper.needToUpdate = false;
    }

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
