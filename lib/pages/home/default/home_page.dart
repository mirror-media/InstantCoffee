import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/onBoarding/bloc.dart';
import 'package:readr_app/pages/home/default/home_widget.dart';
import 'package:readr_app/helpers/app_link_helper.dart';
import 'package:readr_app/helpers/firebase_messaging_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/pages/termsOfService/m_m_terms_of_service_page.dart';
import 'package:readr_app/helpers/data_constants.dart';

class HomePage extends StatefulWidget {
  final GlobalKey settingKey;
  const HomePage({
    required this.settingKey,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late OnBoardingBloc _onBoardingBloc;

  final LocalStorage _storage = LocalStorage('setting');
  final AppLinkHelper _appLinkHelper = AppLinkHelper();
  final FirebaseMessangingHelper _firebaseMessangingHelper =
      FirebaseMessangingHelper();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _appLinkHelper.configAppLink(context);
      _appLinkHelper.listenAppLink(context);
      _firebaseMessangingHelper.configFirebaseMessaging();
    });
    _onBoardingBloc = context.read<OnBoardingBloc>();

    _showTermsOfService();
    super.initState();
  }

  _showTermsOfService() async {
    if (await _storage.ready) {
      bool? isAcceptTerms = await _storage.getItem("isAcceptTerms");
      if (isAcceptTerms == null || !isAcceptTerms) {
        _storage.setItem("isAcceptTerms", false);
        await Future.delayed(const Duration(seconds: 1));
        await Navigator.of(context).push(PageRouteBuilder(
            barrierDismissible: false,
            pageBuilder: (BuildContext context, _, __) =>
                MMTermsOfServicePage()));
      }
    }
  }

  @override
  void dispose() {
    _appLinkHelper.dispose();
    _firebaseMessangingHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildBar(context), body: HomeWidget());
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        key: widget.settingKey,
        icon: const Icon(Icons.settings),
        onPressed: () =>
            RouteGenerator.navigateToNotificationSettings(_onBoardingBloc),
      ),
      backgroundColor: appColor,
      centerTitle: true,
      title: const Text(appTitle),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => RouteGenerator.navigateToSearch(),
        ),
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Member',
          onPressed: () => RouteGenerator.navigateToLogin(),
        ),
      ],
    );
  }
}
