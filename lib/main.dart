import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize without device test ids.
  Admob.initialize();
  // Or add a list of test ids.
  // Admob.initialize(testDeviceIds: ['YOUR DEVICE ID']);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // force portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp(
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
    );
  }
}