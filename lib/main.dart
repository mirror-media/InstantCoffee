import 'package:flutter/material.dart';
import 'package:readr_app/helpers/Constants.dart';
import 'LatestPage.dart';
//import 'HomePage.dart';

void main() {
  runApp(MirrorApp());
}

class MirrorApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    latestPageTag: (context) => LatestPage(),
  };

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: new ThemeData(
        primaryColor: appColor,
      ),
      home: LatestPage(),
      routes: routes,
    );
  }
}
