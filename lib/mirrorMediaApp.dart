import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/iAPSubscriptionHelper.dart';
import 'package:readr_app/helpers/remoteConfigHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/services/memberService.dart';

class MirrorMediaApp extends StatefulWidget {
  @override
  State<MirrorMediaApp> createState() => _MirrorMediaAppState();
}

class _MirrorMediaAppState extends State<MirrorMediaApp> {
  RemoteConfigHelper _remoteConfigHelper = RemoteConfigHelper();
  IAPSubscriptionHelper _iapSubscriptionHelper = IAPSubscriptionHelper();

  @override
  void initState() {
    _remoteConfigHelper.initialize();
    _iapSubscriptionHelper.setSubscription();
    super.initState();
  }

  @override
  void dispose() {
    _iapSubscriptionHelper.cancelSubscriptionStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // force portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return BlocProvider(
      create: (BuildContext context) => MemberBloc(memberRepos: MemberService()),
      child: MaterialApp(
        navigatorKey: RouteGenerator.navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('zh', 'TW'), // Traditional Chinese
          // ... other locales the app supports
        ],
        title: appTitle,
        theme: ThemeData(
          primaryColor: appColor,
        ),
        initialRoute: RouteGenerator.root,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}