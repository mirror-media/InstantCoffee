import 'dart:io';

import 'package:flutter/material.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/mirrorApp.dart';
import 'package:readr_app/models/magazine.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/pages/emailLogin/emailLoginPage.dart';
import 'package:readr_app/pages/emailRegistered/emailRegisteredPage.dart';
import 'package:readr_app/pages/emailVerification/emailVerificationPage.dart';
import 'package:readr_app/pages/login/loginPage.dart';
import 'package:readr_app/pages/magazineBrowser.dart';
import 'package:readr_app/pages/magazine/magazinePage.dart';
import 'package:readr_app/pages/notificationSettingsPage.dart';
import 'package:readr_app/pages/passwordReset/passwordResetPage.dart';
import 'package:readr_app/pages/passwordResetEmail/passwordResetEmailPage.dart';
import 'package:readr_app/pages/passwordResetPrompt/passwordResetPromptPage.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdatePage.dart';
import 'package:readr_app/pages/search/searchPage.dart';
import 'package:readr_app/pages/storyPage.dart';
import 'package:readr_app/widgets/deleteMemberWidget.dart';
import 'package:readr_app/pages/memberCenter/editMemberProfile/editMemberProfilePage.dart';
import 'package:readr_app/pages/memberCenter/editMemberContactInfo/editMemberContactInfoPage.dart';
import 'package:url_launcher/url_launcher.dart';

class RouteGenerator {
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
  static const String magazine = '/magazine';
  static const String magazineBrowser = '/magazineBrowser';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MirrorApp()
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
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PasswordUpdatePage(
            passwordUpdateBloc: args['passwordUpdateBloc'],
          ),
          fullscreenDialog: true,
        );
      case editMemberProfile:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberProfilePage(
            editMemberProfileBloc: args['editMemberProfileBloc'],
          ),
          fullscreenDialog: true,
        );
      case editMemberContactInfo:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => EditMemberContactInfoPage(
            editMemberContactInfoBloc: args['editMemberContactInfoBloc'],
          ),
          fullscreenDialog: true,
        );
      case deleteMember:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => DeleteMemberWidget(
            member: args['member'],
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
              isListeningWidget: args['isListeningWidget']??false,
            )
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case magazine:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MagazinePage()
        );
      case magazineBrowser:
        Map args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MagazineBrowser(
            magazine: args['magazine'],
          )
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

  static void navigateToSearch(BuildContext context) {
    Navigator.of(context).pushNamed(search);
  }

  static void navigateToLogin(
    BuildContext context, 
    {
      String routeName = login,
      Object routeArguments,
    }
  ) {
    Navigator.of(context).pushNamed(
      login,
      arguments: {
        'routeName': routeName,
        'routeArguments': routeArguments,
      },
    );
  }

  static Future<void> navigateToEmailRegistered(
    BuildContext context, 
    {
      String email,
    }
  ) async{
    await Navigator.of(context).pushNamed(
      emailRegistered,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToEmailLogin(
    BuildContext context, 
    {
      String email,
    }
  ) async{
    await Navigator.of(context).pushNamed(
      emailLogin,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToPasswordResetPrompt(
    BuildContext context,
    {
      String email,
    }
  ) async{
    await Navigator.of(context).pushNamed(
      passwordResetPrompt,
      arguments: {
        'email': email,
      },
    );
  }

  static Future<void> navigateToPasswordResetEmail(
    BuildContext context,
    {
      String email,
    }
  ) async{
    await Navigator.of(context).pushNamed(
      passwordResetEmail,
      arguments: {
        'email': email,
      },
    );
  }
  
  static void navigateToPasswordReset(
    BuildContext context, 
    {
      String code,
    }
  ) {
    Navigator.of(context).pushNamed(
      passwordReset,
      arguments: {
        'code': code,
      },
    );
  }

  static Future<void> navigateToPasswordUpdate(
    BuildContext context,
    PasswordUpdateBloc passwordUpdateBloc,
  ) async{
    await Navigator.of(context).pushNamed(
      passwordUpdate,
      arguments: {
        'passwordUpdateBloc': passwordUpdateBloc,
      },
    );
  }

  static Future<void> navigateToEditMemberProfile(
    BuildContext context,
    EditMemberProfileBloc editMemberProfileBloc,
  ) async{
    await Navigator.of(context).pushNamed(
      editMemberProfile,
      arguments: {
        'editMemberProfileBloc': editMemberProfileBloc,
      },
    );
  }

  static Future<void> navigateToEditMemberContactInfo(
    BuildContext context,
    EditMemberContactInfoBloc editMemberContactInfoBloc,
  ) async{
    await Navigator.of(context).pushNamed(
      editMemberContactInfo,
      arguments: {
        'editMemberContactInfoBloc': editMemberContactInfoBloc,
      },
    );
  }

  static void navigateToDeleteMember(
    BuildContext context, 
    Member member, 
  ) {
    Navigator.of(context).pushNamed(
      deleteMember,
      arguments: {
        'member': member,
      },
    );
  }

  static void navigateToEmailVerification(BuildContext context) {
    Navigator.of(context).pushNamed(emailVerification,);
  }

  static void navigateToNotificationSettings(BuildContext context, OnBoardingBloc onBoardingBloc) {
    Navigator.of(context).pushNamed(
      notificationSettings,
      arguments: onBoardingBloc,
    );
  }

  static void navigateToStory(BuildContext context, String slug, {bool isListeningWidget = false}) {
    Navigator.of(context).pushNamed(
      story,
      arguments: {
        'slug': slug,
        'isListeningWidget': isListeningWidget,
      },
    );
  }

  static void navigateToMagazine(BuildContext context) {
    Navigator.of(context).pushNamed(
      magazine,
    );
  }

  static void navigateToMagazineBrowser(
    BuildContext context,
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
      Navigator.of(context).pushNamed(
        magazineBrowser,
        arguments: {
          'magazine': magazine,
        },
      );
    }
  }

  static void printRouteSettings(BuildContext context) {
    var route = ModalRoute.of(context);
    if(route!=null){
      print('route is current: ${route.isCurrent}');
      print('route name: ${route.settings.name}');
      print('route arg: ${route.settings.arguments.toString()}');
    }
  }
}