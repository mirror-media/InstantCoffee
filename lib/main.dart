import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: appTitle,
      theme: ThemeData(
        primaryColor: appColor,
      ),
      initialRoute: RouteGenerator.root,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}