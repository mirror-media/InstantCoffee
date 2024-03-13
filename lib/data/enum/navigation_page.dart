import 'package:readr_app/routes/routes.dart';

enum NavigationPage {
  search,
  bookmark,
  home,
  premium,
  account,
}

extension NavigationExtension on NavigationPage {
  String get router {
    switch (this) {
      case NavigationPage.search:
        return Routes.search;
      case NavigationPage.bookmark:
        return Routes.bookmark;
      case NavigationPage.home:
        return Routes.home;
      case NavigationPage.premium:
        return Routes.premiumArticle;
      case NavigationPage.account:
        return Routes.account;
    }
  }
}
