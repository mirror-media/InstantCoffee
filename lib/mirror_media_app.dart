import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/iap_subscription_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/pages/home/home_binding.dart';
import 'package:readr_app/services/member_service.dart';

class MirrorMediaApp extends StatefulWidget {
  const MirrorMediaApp({Key? key}) : super(key: key);

  @override
  State<MirrorMediaApp> createState() => _MirrorMediaAppState();
}

class _MirrorMediaAppState extends State<MirrorMediaApp> {
  final IAPSubscriptionHelper _iapSubscriptionHelper = IAPSubscriptionHelper();

  @override
  void initState() {
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
      create: (BuildContext context) =>
          MemberBloc(memberRepos: MemberService()),
      child: GetMaterialApp(
        navigatorKey: RouteGenerator.navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('zh', 'TW'), // Traditional Chinese
          // ... other locales the app supports
        ],
        title: appTitle,
        theme: ThemeData(
          primaryColor: appColor,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              actionsIconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                  fontFamily: 'PingFang TC',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
        ),
        initialBinding: HomeBinding(),
        initialRoute: RouteGenerator.root,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
