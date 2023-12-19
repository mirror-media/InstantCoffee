import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/pages/home/default/home_widget.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:readr_app/widgets/header_bar/header_bar.dart';

class HomePage extends GetView<HomeController> with WidgetsBindingObserver {
  final GlobalKey settingKey;

  const HomePage({
    Key? key,
    required this.settingKey,
  }) : super(key: key);

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        key: settingKey,
        icon: const Icon(Icons.settings),
        onPressed: () => RouteGenerator.navigateToNotificationSettings(
            controller.onBoardingBloc),
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

  @override
  Widget build(BuildContext context) {
    controller.setContext(context);
    return SafeArea(
      child: Scaffold(
          appBar: HeaderBar(
            text: 'hello world',
          ),
          body: HomeWidget()),
    );
  }
}
