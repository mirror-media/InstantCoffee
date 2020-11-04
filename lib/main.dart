import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readr_app/helpers/appUpgradeHelper.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();
  // Or add a list of test ids.
  // Admob.initialize(testDeviceIds: ['YOUR DEVICE ID']);

  runApp(MirrorApp());
}

class MirrorApp extends StatefulWidget {
  @override
  _MirrorAppState createState() => _MirrorAppState();
}

class _MirrorAppState extends State<MirrorApp> {
  AppUpgradeHelper _appUpgradeHelper;
  StreamController _configController;

  bool _isUpdateAvailable = false;

  final routes = <String, WidgetBuilder>{
    latestPageTag: (context) => HomePage(),
  };

  @override
  void initState() {
    _appUpgradeHelper = AppUpgradeHelper();
    _configController = StreamController<bool>();
    _waiting();
    super.initState();
  }

  _waiting() async{
    _isUpdateAvailable = await _appUpgradeHelper.isUpdateAvailable();
    print(_isUpdateAvailable);
    // await Future.delayed(Duration(seconds: 3));
    _configController.sink.add(true);
  }

  @override
  void dispose() {
    _configController.close();
    super.dispose();
  }

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
      home: StreamBuilder<bool>(
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

          return HomePage(isUpdateAvailable: _isUpdateAvailable,);
        }
      ),
      routes: routes,
    );
  }
}
