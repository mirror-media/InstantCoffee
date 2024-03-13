import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/pages/home/home_binding.dart';
import 'package:readr_app/pages/home/home_page.dart';
import 'package:readr_app/pages/login/login_page.dart';
import 'package:readr_app/pages/search/search_binding.dart';
import 'package:readr_app/pages/search/search_page.dart';
import 'package:readr_app/routes/routes.dart';

class Pages {
  static final pages = [];

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return GetPageRoute(
          settings: settings,
          page: () => const HomePage(),
          binding: HomeBinding(settings.arguments),
        );
      case Routes.account:
        return GetPageRoute(
          settings: settings,
          page: () => const LoginPage(),
        );
      case Routes.search:
        return GetPageRoute(
          settings: settings,
          page: () => const SearchPage(),
          binding: SearchBinding(),
        );
    }

    return null;
  }
}
