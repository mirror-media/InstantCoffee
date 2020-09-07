import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/homePage.dart';

void main() {
  runApp(MirrorApp());
}

class MirrorApp extends StatefulWidget {
  @override
  _MirrorAppState createState() => _MirrorAppState();
}

class _MirrorAppState extends State<MirrorApp> {
  StreamController _configController;
  final routes = <String, WidgetBuilder>{
    latestPageTag: (context) => HomePage(),
  };

  @override
  void initState() {
    _configController = StreamController<bool>();
    _waiting();
    super.initState();
  }

  _waiting() async{
    await Future.delayed(Duration(seconds: 3));
    _configController.sink.add(true);
  }

  @override
  void dispose() {
    _configController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          return HomePage();
        }
      ),
      routes: routes,
    );
  }
}
