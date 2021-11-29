import 'dart:io';

import 'package:flutter/material.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/initialApp.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/emailLogin/emailLoginPage.dart';
import 'package:readr_app/pages/emailRegistered/emailRegisteredPage.dart';
import 'package:readr_app/pages/emailVerification/emailVerificationPage.dart';
import 'package:readr_app/pages/login/loginPage.dart';
import 'package:readr_app/pages/magazineBrowser.dart';
import 'package:readr_app/pages/magazine/magazinePage.dart';
import 'package:readr_app/pages/memberCenter/deleteMember/deleteMemberPage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/hintToWebsitePage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/newebpayChangePlanPage.dart';
import 'package:readr_app/pages/notificationSettingsPage.dart';
import 'package:readr_app/pages/passwordReset/passwordResetPage.dart';
import 'package:readr_app/pages/passwordResetEmail/passwordResetEmailPage.dart';
import 'package:readr_app/pages/passwordResetPrompt/passwordResetPromptPage.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdatePage.dart';
import 'package:readr_app/pages/search/searchPage.dart';
import 'package:readr_app/pages/storyPage/listening/listeningStoryPage.dart';
import 'package:readr_app/pages/storyPage/news/storyPage.dart';

import 'package:readr_app/pages/memberCenter/editMemberProfile/editMemberProfilePage.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/editMemberContactInfoPage.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();  

  static const String root = '/';
  static const String search = '/search';
  static const String login = '/login';
  static const String emailRegistered = '/emailRegistered';
  static const String emailLogin = '/emailLogin';
  static const String passwordResetPrompt = '/passwordResetPrompt';
  static const String passwordResetEmail = '/passwordResetEmail';
  static const String passwordReset = '/passwordReset';
  static const String passwordUpdate = '/passwordUpdate';
  static const String editMemberProfile = '/editMemberProfile';
  static const String editMemberContactInfo = '/editMemberContactInfo';
  static const String deleteMember = '/deleteMember';
  static const String emailVerification = '/emailVerification';
  static const String notificationSettings = '/notificationSettings';
  static const String story = '/story';
  static const String listeningStory = '/listeningStory';
  static const String magazine = '/magazine';
  static const String magazineBrowser = '/magazineBrowser';
  static const String subscriptionSelect = '/subscriptionSelect';
  static const String newebpayChangePlan = '/newebpayChangePlan';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => InitialApp()
        );
      case search:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SearchPage(),
          fullscreenDialog: true,
        );
      case login:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => LoginPage(
            routeName: args['routeName']??login,
            routeArguments: args['routeArguments'],
          ),
          fullscreenDialog: true,
        );
      case emailRegistered:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EmailRegisteredPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case emailLogin:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EmailLoginPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case passwordResetPrompt:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => PasswordResetPromptPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case passwordResetEmail:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => PasswordResetEmailPage(
            email: args['email'],
          ),
          fullscreenDialog: true,
        );
      case passwordReset:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PasswordResetPage(
            code: args['code'],
          ),
          fullscreenDialog: true,
        );
      case passwordUpdate:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PasswordUpdatePage(),
          fullscreenDialog: true,
        );
      case editMemberProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberProfilePage(),
          fullscreenDialog: true,
        );
      case editMemberContactInfo:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberContactInfoPage(),
          fullscreenDialog: true,
        );
      case deleteMember:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => DeleteMemberPage(
            israfelId: args['israfelId'],
            subscritionType: args['subscritionType'],
          ),
          fullscreenDialog: true,
        );
      case emailVerification:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EmailVerificationPage(),
          fullscreenDialog: true,
        );
      case notificationSettings:
        Object args = settings.arguments;
        // Validation of correct data type
        if (args is OnBoardingBloc) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => NotificationSettingsPage(
              onBoardingBloc: args,
            ),
            fullscreenDialog: true,
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case story:
        Map args = settings.arguments;
        // Validation of correct data type
        if (args['slug'] is String) {
          return MaterialPageRoute(
            builder: (context) => StoryPage(
              slug: args['slug'],
              isMemberCheck: args['isMemberCheck'],
            )
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case listeningStory:
        Map args = settings.arguments;
        // Validation of correct data type
        if (args['slug'] is String) {
          return MaterialPageRoute(
            builder: (context) => ListeningStoryPage(
              slug: args['slug'],
            )
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case magazine:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MagazinePage(
            subscritionType: args['subscritionType'],
          )
        );
      case magazineBrowser:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MagazineBrowser(
            magazine: args['magazine'],
          )
        );
      case subscriptionSelect:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HintToWebsitePage(args['subscritionType']),
          // builder: (_) => SubscriptionSelectPage(args['subscritionType']),
        );
      case newebpayChangePlan:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => NewebpayChangePlanPage(),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR'),
          ),
        );
      }
    );
  }

  static void navigateToSearch() {
    navigatorKey.currentState.pushNamed(search);
  }

  static void navigateToLogin(
    {
      String routeName = login,
      Object routeArguments,
    }
  ) {
    navigatorKey.currentState.pushNamed(
      login,
      arguments: {
        'routeName': routeName,
        'routeArguments': routeArguments,
      },
    );
  }

  static Future<void> navigateToEmailRegistered(
    {
      String email,
    }
  ) async{
    await navigatorKey.currentState.pushNamed(
      emailRegistered,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToEmailLogin(
    {
      String email,
    }
  ) async{
    await navigatorKey.currentState.pushNamed(
      emailLogin,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToPasswordResetPrompt(
    {
      String email,
    }
  ) async{
    await navigatorKey.currentState.pushNamed(
      passwordResetPrompt,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToPasswordResetEmail(
    {
      String email,
    }
  ) async{
    await navigatorKey.currentState.pushNamed(
      passwordResetEmail,
      arguments: {
        'email': email,
      },
    );
  }
  
  static void navigateToPasswordReset(
    {
      String code,
    }
  ) {
    navigatorKey.currentState.pushNamed(
      passwordReset,
      arguments: {
        'code': code,
      },
    );
  }

  static void navigateToPasswordUpdate() {
    navigatorKey.currentState.pushNamed(passwordUpdate);
  }

  static void navigateToEditMemberProfile() {
    navigatorKey.currentState.pushNamed(editMemberProfile);
  }

  static void navigateToEditMemberContactInfo() {
    navigatorKey.currentState.pushNamed(editMemberContactInfo);
  }

  static void navigateToDeleteMember(
    String israfelId,
    SubscritionType subscritionType
  ) {
    navigatorKey.currentState.pushNamed(
      deleteMember,
      arguments: {
        'israfelId': israfelId,
        'subscritionType': subscritionType,
      },
    );
  }

  static void navigateToEmailVerification() {
    navigatorKey.currentState.pushNamed(emailVerification,);
  }

  static void navigateToNotificationSettings(OnBoardingBloc onBoardingBloc) {
    navigatorKey.currentState.pushNamed(
      notificationSettings,
      arguments: onBoardingBloc,
    );
  }

  static void navigateToStory(
    String slug,
    {bool isMemberCheck = true}
  ) {
    navigatorKey.currentState.pushNamed(
      story,
      arguments: {
        'slug': slug,
        'isMemberCheck': isMemberCheck
      },
    );
  }

  static void navigateToListeningStory(String slug) {
    navigatorKey.currentState.pushNamed(
      listeningStory,
      arguments: {
        'slug': slug
      },
    );
  }

  static void navigateToMagazine(
    SubscritionType subscritionType,
  ) {
    navigatorKey.currentState.pushNamed(
      magazine,
      arguments: {
        'subscritionType': subscritionType
      },
    );
  }

  static void navigateToMagazineBrowser(
    Magazine magazine
  ) async{
    // https://github.com/flutter/flutter/issues/48245
    // There is a issue when opening pdf file in webview on android, 
    // so change to launch URL on android.
    if(Platform.isAndroid) {
      if (await canLaunch(magazine.pdfUrl)) {
        await launch(magazine.pdfUrl);
      } else {
        throw 'Could not launch $magazine.pdfUrl';
      }
    } else {
      navigatorKey.currentState.pushNamed(
        magazineBrowser,
        arguments: {
          'magazine': magazine,
        },
      );
    }
  }

  static void navigateToSubscriptionSelect(
    SubscritionType subscritionType,
    {
    bool usePushReplacement = false, 
    bool isNewebpay = false,
    }
  ) {
    if(usePushReplacement){
      navigatorKey.currentState.pushReplacementNamed(
        subscriptionSelect,
        arguments: {
          'subscritionType': subscritionType
        },
      );
    }else if(isNewebpay){
      navigatorKey.currentState.pushNamed(
        newebpayChangePlan,
      );
    }
    else{
      navigatorKey.currentState.pushNamed(
        subscriptionSelect,
        arguments: {
          'subscritionType': subscritionType
        },
      );
    }
  }

  static void printRouteSettings() {
    var route = ModalRoute.of(navigatorKey.currentContext);
    if(route!=null){
      print('route is current: ${route.isCurrent}');
      print('route name: ${route.settings.name}');
      print('route arg: ${route.settings.arguments.toString()}');
    }
  }
}